## Configuration
### Common configuration items
#### Logging

Logging functionality of all Data Transfer services is provided by Serilog library.

```json
 "Serilog": {
    "MinimumLevel": {
      "Default": "Debug",
      "Override": {
        "Microsoft": "Warning",
        "System": "Warning"
      }
```
`MinimumLevel` options sets the minimum severity level of messages that will be put in the log.
Serilog supports 5 different logging levels: `Verbose`, `Debug`, `Information`, `Warning`, `Error` and `Fatal`. 
This option can be changes at the runtime and will take effect immediately.

```json
    },
    "Enrich": [ "WithMachineName", "WithProcessName", "WithThreadId" ],
```
`Enrich` specifies additional information that will be added to all log entries. For more information refer to enrichers [documentation](https://github.com/serilog/serilog/wiki/Enrichment)

```json
    "WriteTo": [
```
`WriteTo` section specifies list of all destination that logs will be saved to. By default only destination is `File`. Other possible and useful option could be `Console.

```json
      {
        "Name": "File",
        "Args": {
          "path": ".\\log.json",
          "formatter": "Serilog.Formatting.Json.JsonFormatter, Serilog"
```
`path` defines location and name of the log file.
`formatter` defines the way of storing log data. By default logs are stored as a json file. For more options refer to formatters [documentation](https://github.com/serilog/serilog/wiki/Formatting-Output).
Other useful options in `Args` section are:
- `rollOnFileSizeLimit` - enables log rotation when `fileSizeLimitBytes` is reached (bool, default is false).
- `fileSizeLimitBytes` - specifies maximum size of log file in bytes (default is 1 GB).
- `retainedFileCountLimit` - specifies how many log files will be kept. Default value is 31. Use `null` to disable the limit.
- `rollingInterval` - enables log rotation when specific interval elapses (e.g. `Day`, `Month`, `Year`)

More information can be found in serilog file sink [documentation](https://github.com/serilog/serilog-sinks-file).

#### Brokers Configuration

ImportExport services operate on AMQP entities. AMQP broker is a piece of software capable of relaying messages from one service to another.
`BrokersConfiguration` configuration item allows the user to specify broker connection strings - we allow to specify more than one connection string.
In case of connection failure, the service will choose the next connection string from the list and will try to establish a new connection.

```json
  "BrokersConfiguration": {
    "B1": {
      "ConnectionStrings": [
        "amqp://localhost:5672",
        "amqp://otherhost:5672"
      ]
    },
    "B2": {
      "ConnectionStrings": [
        "amqp://localhost:5672"
      ]
    }
  },
```

Each connection string should start with:
- `amqp://` - Non secure amqp connection will be created. Messages will be sent using AMQP protocol.
- `amqps://` - Secure amqp connection will be created. Messages will be sent using AMQP protocol.
- `Endpoint=sb://` - Instead of using AMQP protocol, Azure Service Bus communication library will be used for connection and messaging.

We support RabbitMQ Virtual Host feature (see [RabbitMQ docs](https://www.rabbitmq.com/docs/vhosts)). Example Virtual Host configuration:

```json
  "BrokersConfiguration": {
    "B1": {
      "ConnectionStrings": [
        "amqp://localhost:5672",
        "amqp://otherhost:5672"
      ],
      "VirtualHost": "Virtus"
    }
  },
```

#### Queues Configuration

`Trigger Relay` and `Mesh Amqp Relay` allow configuration of queues that can be later assigned to various components.
Each json object in `Queues Configuration` describes single queue. It can have any name that is unique within `Queues Configuration`.

```json
"QueuesConfiguration": {
    "Queue1": {
      "Broker": "B1",
```
`Broker` is a reference to one of the broker names defined in the `BrokersConfiguration`, for example `B1`.

```json
      "QueueName": "exportQueue",
```
`QueueName` specifies a queue to connect to on the broker.
```json
      "Role": "Sender",
```
`Role` specifies whether this queue will be used to send to or receive from. Valid values are: `Sender`, `Receiver`, `Failure`, `Confirmation` and `ReimportSender`.

```json
      "Priority": 0
```

`Priority` is an integer used for indicating import queue priority. Based on this number (the lower the number, the more important given queue is) MAR will process messages
placed in the queues with higher priority before messages placed in the queues with lower priorities. If the queue doesn't have the `Priority` parameter specified, its default priority is 50. Example: there are 3 import queues defined with following priorities: 0, 1 and for the last queue the `Priority` parameter is missing (it results to priority 50). Messages in the queue with priority 0 will be handled first, then messages in the queue with priority 1 and at the end the messages in the queue with priority 50.

#### Kestrel Configuration

`Kestrel` is an http server used by `Trigger Relay`, `Export Data Store` and `Database Gateway` in order to expose endpoints for receiving orders data and for health endpoints.

```json
"Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://localhost:7000"
```
`Url` specifies address and port that should be used when accessing the service. For most cases it is reasonable to replace `localhost` with machine `hostname`.

#### HttpEndpoints configuration 

```json
"HttpEndpoints": {
  "Mesh": {
    "Uri": "https://localhost:20000/mesh",
    "ServerPrincipal": "HOST/server.mydomain.com",
    "TokenRefreshIntervalMinutes": 30,
    "RequestTimeout": 60,
    "MaxReceiveMessageSizeInBytes": 16777216
  },
  "ExportDataStore": {
    "Uri": "http://localhost:17000/"
  },
  "DatabaseGateway": {
    "Uri": "http://localhost:7137"
  }
},
```

This part applies to `Trigger Relay` or `Mesh Amqp Relay`, depending on which export flow is in use.

`HttpEndpoints:Mesh:Uri` contains address of `Mesh` server endpoint that will be used for all exports and imports of data.
Use `https` in the `Uri` to enable Transport Layer Security (TLS) and communicate with Mesh over secure channel.

`HttpEndpoints:Mesh:ServerPrincipal` field should be set if the user wants to enable Kerberos authentication.
The value should be set to Kerberos server principal of the Mesh server.
`HttpEndpoints:Mesh:TokenRefreshIntervalMinutes` is the refresh period of the Kerberos token. By default it is set to 30 minutes.

`HttpEndpoints:Mesh:MaxReceiveMessageSizeInBytes` is an optional size limit for the messages received from Mesh (e.g. time series export response). Defaults to 4 MB (4194304 bytes) when not provided. The example extends the received message size limit to 16 MB.

`HttpEndpoints:ExportDataStore`  is an address of `Export Data Store` endpoint (formerly `ExportWorker:ExportServiceAddress`). This is the address that will be used to send all timeseries export data, received from `Mesh`, in order to store it and create `Message Log` entries.

`HttpEndpoints:DatabaseGateway` is the address of `DatabaseGateway` service endpoint.

All of the endpoints above can specify an optional `RequestTimeout` attribute (defaults to `60`).

#### Database Configuration

The `Database Gateway` service requires direct database access. Currently data required to access the database is stored in the configuration file.


```json
"Database": {
    "User": "dbuser",
    "Password": "dbpass",
    "DataSource": "dbserver",
    "OpunKeyMode": "SHORNAME" // legal values: SHORNAME/BANKACC/POSTACC/ESETT_ID, SHORNAME is default if not specified
  }
```

### Trigger Relay Specific Configuration:
```json
{
  "AmqpSender": {
    "Queues": [
      "ExportQueue"
    ]
  },
```
`AmqpSender` is used to send export orders to the AMQP queues. `Queues` is expected to contains single `Sender` queue name defined in `QueuesConfiguration` configuration item.
```json
  "AdditionalPvplanPrefix": {
    "Separator": ";"
  },
```
`AdditionalPvplanPrefix` separator is a character used in Participant application export definition. It separates External Reference from prefix string being added to the PVPLAN data file names.
```json
  "ContentCode": {
    "Separator":  ";"
  },
}
```
`ContentCode` separator is a character used in Participant application export definition. It separates Product Code from exact protocol name ('APOR' or 'APOT') in case of APOR/APOT export.

```json
"HttpEndpoints": {
  "DatabaseGateway": {
    "Uri": "http://localhost:7137"
  }
}
```

`HttpEndpoints:DatabaseGateway` specifies the endpoint of `Database Gateway` service. It accepts an optional `RequestTimeout` attribute (defaults to `60`).

```json
"ParticipantSettings": {
  "DefaultSender": 26
}
```

`ParticipantSettings:DefaultSender` specifies the default sender to be used when exporting time series or availability data. The `DefaultSender` participant key is used as a fallback when the sender is not defined in the time series export definition or in the export request.

### Mesh Amqp Relay Specific Configuration:

```json
  "ImportWorker": {
    "Queues": [
      "Q3",
      "Q4",
      "FailureQ"
    ],
    "ICC_TRANSLOG_DIR": "C:\\ICC_TRANSLOG_DIR\\",
    "ReimportEnabled": false,
    "PartialImportSuccess": false
  },
```
`ImportWorker` is used to handle import requests. In order to work properly it needs `Queues` to contain a list of queues from `QueuesConfiguration`. One of the queues needs to be a `Receiver` queue which will be used to receive import orders. Second queues needs to be a `Sender` queue, it will be used for sending import status data.
The third, optional queue, needs to be a `Failure` queue. Its use depends on `FailedMessages` node below.
If `ReimportEnabled` flag is set to `true`, `ICC_TRANSLOG_DIR` is a directory where received import requests are kept for potential reimports.
`PartialImportSuccess` is an optional flag that makes Mesh Data Transfer include `<ImportSuccess>true</ImportSuccess>` in the time series import reply when the import was partially successful. The default value is `false`, which means `ImportSuccess` is `true` only when all of the requested time series were imported correctly.

```json
  "ExportWorker": {
    "Queues": [
      "Q1",
      "FailureQ"
    ]
  },
```
`ExportWorker` is used to handle export requests. In order to work properly it needs `Queues` to contain a list of two queues from `QueuesConfiguration`. One of the queues needs to be a `Receiver` queue which will be used to receive export orders. Second queues needs to be a `Sender` queue, it will be used for sending export data. The `Sender` queue will be used only for timeseries exports that are defined as a `StdExport` and all `Availability` exports. More information about export types can be found in the `Export Protocols` section.

```json
  "MeshMonitor": {
    "MeshHealthEndpoint": "http://localhost:20000/meshHealth/health",
    "CheckInterval": 5000
  }
```
`MeshMonitor` contains address of `Mesh` server health endpoint. It will be used to establish whether `Mesh` is in suitable condition to perform exports and imports.

```json
  "FailedMessages": {
    "UseFailureQueueOnInternalError": true,
    "UseFailureQueueOnExternalError": false
  },
```

Internal errors are the ones that originated from inside `Mesh AMQP Relay` (for example `XML`/`JSON` parsing problem). 
External errors come from `Mesh` and `EDS` (like an `Oracle` issue). If set to true the problematic message will be sent to failure queue.
Otherwise the application will try to put it back on the queue process it again.

### Export Data Store Specific Configuration:

'MercatoMapping' is used only for Bidding Strategy export protocol. It associates numbers with user-defined strings.
They are used later in the Bidding Strategy export file to map timeseries values to strings.

```json
  "MercatoMapping": {
    "0": "MGP",
    "1": "MI1",
    "2": "MI2",
    "3": "MI3",
    "4": "MI4",
    "5": "MI5",
    "6": "MI6",
    "7": "MI7",
    "8": ""
  },
```

`UnitScheduleMapping` is similar to `MercatoMapping`. It is used for Bidding Strategy export protocol as well.

```json
  "UnitScheduleMapping": {
    "A": "dummyA",
    "B": "dummyB"
  },
```

`StoragePerProtocol` node contains storage settings for each protocol. `StorageKinds` valid values are `File` and `Queue` - it is allowed to specify the target storage: filesystem, AMQP/ServiceBus queue or both.
Parameter called `StoragePath` specifies disk storage location in case of the `StorageKinds` array containing a `File` value. 

`DestinationQueues` is a (protocol, receiver)-to-queue mapping. It is a dictionary consisting of keys being export receiver identfiers and values being queue aliases arrays.
When the `DestinationQueues` contains a key equal to an export receiver value for given export protocol, the export data will be sent to the queues in the respective array.

In the `StoragePerProtocol` nodes there is also an array called `DefaultQueues`.
If the `DestinationQueues` mapping does not provide target queue information needed, `DefaultQueues` values are used as target queues.

It is allowed to have one of (`DestinationQueues`, `DefaultQueues`) empty, but not both.

Another parameter for `StoragePerProtocol` nodes is `DefaultDecimals`. It defines the number of decimals that is saved in the exported time series values if the decimals parameter is not defined in the time series export definition. It is optional and currently it is only supported for EDIEL DELFOR, ExcelCSV and GS2 export types.

`ICC_TRANSLOG_DIR` is a directory where export files are kept in order to look them up from MessageLog application.
Please make sure that these directories are created.
`AvailabilityExportQueue` is a reference to one of the queues defined in `QueuesConfiguration` item.
```json
  "Storage": {
    "StoragePerProtocol": {
      "PVPLAN": {
        "StorageKinds": [ "Queue" ],
        "DestinationQueues": {
          "1": [ "exportReplyQueue" ],
          "13": [ "exportReplyQueue", "someOtherQueue" ]
        },
        "DefaultQueues": [ "exportReplyQueue" ]
      },
      "PVPLAN2023": {
        "StorageKinds": [ "File" ],
        "StorePath": "C:\\files\\"
      },
      "StdExport": {
        "StorageKinds": [ "Queue" ],
        "DestinationQueues": {
          "1": [ "exportReplyQueue" ],
          "13": [ "exportReplyQueue", "someOtherQueue" ]
        },
        "DefaultQueues": [ "exportReplyQueue" ]
      },
      "APORAPOTExport": {
        "StorageKinds": [ "Queue" ],
        "DestinationQueues": {
          "1": [ "exportReplyQueue" ],
          "2": [ "exportReplyQueue", "someOtherQueue" ]
        },
        "DefaultQueues": [ "exportReplyQueue" ]
      },
      "BiddingTool": {
        "StorageKinds": [ "File" ],
        "StorePath": "C:\\files\\"
      },
      "GS2": {
        "StorageKinds": [ "File" ],
        "StorePath": "C:\\files\\",
        "DefaultDecimals": 3 // optional, used when the time series export definition does not define the decimals parameter; for GS2 the default value is null (number of decimals not specified)
      },
      "EdielDelfor": {
        "StorageKinds": [ "File" ],
        "StorePath": "C:\\files\\",
        "DefaultDecimals": 2 // optional, used when the time series export definition does not define the decimals parameter; for EDIEL DELFOR the default value is 3
      },
      "ExcelCSV": {
        "StorageKinds": [ "File" ],
        "StorePath": "C:\\files\\"
        "DefaultDecimals": 2, // optional, used when the time series export definition does not define the decimals parameter; for Excel CSV the default value is 6
      }
    },
    "ICC_TRANSLOG_DIR": "C:\\ICC_TRANSLOG_DIR\\",
    "AvailabilityExportQueue": "Q",
    "PvPlan2023": false
  },

  "QueuesConfiguration": {
    "exportReplyQueue": {
      "Broker": "B1",
      "QueueName": "exportReplyQueue",
      "Role": "Sender"
    },
    "someOtherQueue": {
      "Broker": "B1",
      "QueueName": "someOtherQueue",
      "Role": "Sender"
    }
  },
```

`HttpEndpoints:DatabaseGateway` specifies the endpoint of `Database Gateway` service. It accepts an optional `RequestTimeout` attribute (defaults to `60`).
```json
"HttpEndpoints": {
  "DatabaseGateway": {
    "Uri": "http://localhost:7137"
  }
}
```
