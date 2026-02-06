workspace "E-Commerce System - Container View" {
    model {
        customer = person "Customer"
        
        paymentGateway = softwareSystem "Payment Gateway" "External"
        emailSystem = softwareSystem "Email Service" "External"

        ecommerceSystem = softwareSystem "E-Commerce Platform" {
            webApp = container "Web Application" "React, TypeScript" {
                technology "Client-side SPA"
                description "Provides browsing and order placement interface"
            }
            apiGateway = container "API Gateway" "Kong, NGINX" {
                technology "API Gateway"
                description "Routes requests to appropriate microservices"
            }

            customerService = container "Customer Service" "Node.js" {
                technology "Microservice"
                description "Manages customer profiles and registrations"
            }
            orderService = container "Order Service" "Node.js" {
                technology "Microservice"
                description "Handles order creation, tracking, and fulfillment"
            }
            productService = container "Product Service" "Node.js" {
                technology "Microservice"
                description "Manages product catalog and inventory"
            }
            paymentService = container "Payment Service" "Node.js" {
                technology "Microservice"
                description "Processes payments and manages payment state"
            }

            messageBroker = container "Message Broker" "RabbitMQ" {
                technology "Event Bus"
                description "Enables asynchronous communication between services"
            }

            customerDB = container "Customer Database" "PostgreSQL" {
                technology "Relational Database"
                description "Stores customer accounts and profiles"
            }
            orderDB = container "Order Database" "PostgreSQL" {
                technology "Relational Database"
                description "Stores order records and order items"
            }
            productDB = container "Product Database" "PostgreSQL" {
                technology "Relational Database"
                description "Stores product catalog and inventory levels"
            }
            paymentDB = container "Payment Database" "PostgreSQL" {
                technology "Relational Database"
                description "Stores payment transactions and history"
            }

            cache = container "Cache" "Redis" {
                technology "In-Memory Cache"
                description "Caches frequently accessed data for performance"
            }
        }

        # User interactions
        customer -> webApp "Uses [HTTPS]"
        webApp -> apiGateway "Makes API calls [REST/JSON]"

        # API Gateway to Microservices
        apiGateway -> customerService "Routes to [REST/JSON]"
        apiGateway -> orderService "Routes to [REST/JSON]"
        apiGateway -> productService "Routes to [REST/JSON]"
        apiGateway -> paymentService "Routes to [REST/JSON]"

        # Microservice to Database connections
        customerService -> customerDB "Reads/Writes [SQL]"
        orderService -> orderDB "Reads/Writes [SQL]"
        productService -> productDB "Reads/Writes [SQL]"
        paymentService -> paymentDB "Reads/Writes [SQL]"

        # Cache interactions
        customerService -> cache "Uses [Redis Protocol]"
        orderService -> cache "Uses [Redis Protocol]"
        productService -> cache "Uses [Redis Protocol]"

        # Asynchronous messaging
        orderService -> messageBroker "Publishes OrderCreated [AMQP]"
        paymentService -> messageBroker "Publishes PaymentProcessed [AMQP]"
        messageBroker -> productService "Delivers OrderCreated [AMQP]"
        messageBroker -> customerService "Delivers PaymentProcessed [AMQP]"

        # Cross-service synchronous calls
        orderService -> productService "Checks inventory [REST]"
        orderService -> customerService "Validates customer [REST]"

        # External integrations
        paymentService -> paymentGateway "Processes payments [HTTPS/API]"
        orderService -> emailSystem "Sends notifications [SMTP/API]"
    }

    views {
        container ecommerceSystem {
            include *
            autoLayout
        }
    }
}
