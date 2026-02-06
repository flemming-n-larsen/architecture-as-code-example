workspace "Payment Service - Component View" {
    model {
        orderService = softwareSystem "Order Service" {
            description "Handles order creation and fulfillment"
        }

        paymentGateway = softwareSystem "Payment Gateway" {
            description "External payment processing provider"
        }

        messageBroker = softwareSystem "Message Broker" {
            description "Event-driven messaging infrastructure"
        }

        paymentDatabase = softwareSystem "Payment Database" {
            description "Persistent storage for payment records"
        }

        paymentService = softwareSystem "Payment Service" {
            paymentController = container "Payment Controller" "REST API" {
                technology "Express.js"
                description "Handles incoming HTTP requests for payment operations"
            }

            paymentManager = container "Payment Manager" "Business Logic" {
                technology "Node.js Service"
                description "Orchestrates payment processing workflow"
            }

            paymentValidator = container "Payment Validator" "Validation" {
                technology "Node.js Module"
                description "Validates payment data, amounts, and business rules"
            }

            paymentStateMachine = container "Payment State Machine" "State Management" {
                technology "Finite State Machine"
                description "Manages payment lifecycle states (pending, processing, authorized, captured, failed, refunded)"
            }

            paymentRepository = container "Payment Repository" "Data Access" {
                technology "Node.js ORM (TypeORM/Sequelize)"
                description "Abstracts database access for payment persistence"
            }

            gatewayIntegration = container "Gateway Integration" "External Integration" {
                technology "Payment Gateway SDK"
                description "Integrates with external payment providers (Stripe, PayPal)"
            }

            paymentEventPublisher = container "Event Publisher" "Message Producer" {
                technology "Node.js AMQP Client"
                description "Publishes payment events to message broker"
            }

            paymentEventSubscriber = container "Event Subscriber" "Message Consumer" {
                technology "Node.js AMQP Client"
                description "Subscribes to order events and external payment notifications"
            }

            refundManager = container "Refund Manager" "Refund Processing" {
                technology "Node.js Service"
                description "Handles refund requests and processing"
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
        paymentController -> paymentValidator "Validates input [JSON]"
        paymentValidator -> errorHandler "Reports validation errors [Exception]"

        paymentController -> paymentManager "Calls process payment [Method Call]"
        paymentManager -> paymentStateMachine "Transitions state [Method Call]"
        paymentManager -> gatewayIntegration "Initiates payment [Method Call]"
        gatewayIntegration -> paymentGateway "Processes payment [HTTPS/API]"

        paymentManager -> paymentRepository "Persists payment [SQL]"
        paymentRepository -> paymentDatabase "Reads/Writes [SQL/PostgreSQL]"

        # Event publishing
        paymentManager -> paymentEventPublisher "Publishes PaymentAuthorized [AMQP]"
        paymentManager -> paymentEventPublisher "Publishes PaymentCaptured [AMQP]"
        paymentEventPublisher -> messageBroker "Sends event [AMQP]"

        # Event subscription
        messageBroker -> paymentEventSubscriber "Delivers OrderCreated [AMQP]"
        paymentEventSubscriber -> paymentManager "Handles OrderCreated [Method Call]"

        # Refund processing
        paymentManager -> refundManager "Initiates refund [Method Call]"
        refundManager -> gatewayIntegration "Refunds payment [Method Call]"
        refundManager -> paymentEventPublisher "Publishes PaymentRefunded [AMQP]"
        refundManager -> paymentRepository "Updates payment record [SQL]"

        # Cross-service calls
        paymentManager -> orderService "Updates order status [REST/JSON]"

        # Logging and error handling
        paymentController -> logger "Logs requests [Method Call]"
        paymentManager -> logger "Logs operations [Method Call]"
        paymentRepository -> logger "Logs database ops [Method Call]"
        gatewayIntegration -> logger "Logs gateway calls [Method Call]"
        refundManager -> logger "Logs refunds [Method Call]"
        errorHandler -> logger "Logs errors [Method Call]"

        # Configuration
        paymentController -> config "Reads config [Property Access]"
        paymentManager -> config "Reads config [Property Access]"
        gatewayIntegration -> config "Reads gateway config [Property Access]"
        paymentEventPublisher -> config "Reads broker config [Property Access]"
    }

    views {
        systemLandscape {
            include *
            autoLayout
        }
    }
}
