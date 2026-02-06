workspace "Order Service - Component View" {
    model {
        customerService = softwareSystem "Customer Service" {
            description "Manages customer accounts and profiles"
        }

        productService = softwareSystem "Product Service" {
            description "Manages product catalog and inventory"
        }

        messageBroker = softwareSystem "Message Broker" {
            description "Event-driven messaging infrastructure"
        }

        orderDatabase = softwareSystem "Order Database" {
            description "Persistent storage for orders"
        }

        orderService = softwareSystem "Order Service" {
            orderController = container "Order Controller" "REST API" {
                technology "Express.js"
                description "Handles incoming HTTP requests for order operations"
            }

            orderManager = container "Order Manager" "Business Logic" {
                technology "Node.js Service"
                description "Orchestrates order creation and processing workflow"
            }

            orderValidator = container "Order Validator" "Validation" {
                technology "Node.js Module"
                description "Validates order data, quantities, and business rules"
            }

            orderStateMachine = container "Order State Machine" "State Management" {
                technology "Finite State Machine"
                description "Manages order lifecycle states (pending, confirmed, shipped, delivered, cancelled)"
            }

            orderRepository = container "Order Repository" "Data Access" {
                technology "Node.js ORM (TypeORM/Sequelize)"
                description "Abstracts database access for order persistence"
            }

            orderEventPublisher = container "Event Publisher" "Message Producer" {
                technology "Node.js AMQP Client"
                description "Publishes order events to message broker"
            }

            orderEventSubscriber = container "Event Subscriber" "Message Consumer" {
                technology "Node.js AMQP Client"
                description "Subscribes to external events (PaymentProcessed, InventoryReserved)"
            }

            errorHandler = container "Error Handler" "Error Management" {
                technology "Node.js Module"
                description "Centralized error handling and retry logic"
            }

            logger = container "Logger" "Logging" {
                technology "Winston/Pino"
                description "Logs application events and debugging information"
            }

            config = container "Configuration" "Settings" {
                technology "Node.js Config"
                description "Manages environment variables and service configuration"
            }
        }

        # Request flow
        orderController -> orderValidator "Validates input [JSON]"
        orderValidator -> errorHandler "Reports validation errors [Exception]"

        orderController -> orderManager "Calls create order [Method Call]"
        orderManager -> orderStateMachine "Transitions state [Method Call]"
        orderManager -> orderRepository "Persists order [SQL]"
        orderManager -> orderValidator "Re-validates [Method Call]"

        orderRepository -> orderDatabase "Reads/Writes [SQL/PostgreSQL]"

        # Event publishing
        orderManager -> orderEventPublisher "Publishes OrderCreated [AMQP]"
        orderEventPublisher -> messageBroker "Sends event [AMQP]"

        # Event subscription
        messageBroker -> orderEventSubscriber "Delivers events [AMQP]"
        orderEventSubscriber -> orderManager "Handles PaymentProcessed [Method Call]"
        orderEventSubscriber -> orderStateMachine "Updates order state [Method Call]"

        # Cross-service calls
        orderManager -> customerService "Validates customer [REST/JSON]"
        orderManager -> productService "Checks inventory [REST/JSON]"

        # Logging and error handling
        orderController -> logger "Logs requests [Method Call]"
        orderManager -> logger "Logs operations [Method Call]"
        orderRepository -> logger "Logs database ops [Method Call]"
        errorHandler -> logger "Logs errors [Method Call]"

        # Configuration
        orderController -> config "Reads config [Property Access]"
        orderManager -> config "Reads config [Property Access]"
        orderRepository -> config "Reads DB config [Property Access]"
        orderEventPublisher -> config "Reads broker config [Property Access]"
    }

    views {
        systemLandscape {
            include *
            autoLayout
        }
    }
}
