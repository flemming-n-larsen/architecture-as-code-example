workspace "E-Commerce System" {
    model {
        customer = person "Customer" {
            description "A customer using the e-commerce platform"
        }

        admin = person "Administrator" {
            description "Administrator managing the platform"
        }

        paymentGateway = softwareSystem "Payment Gateway" "External" {
            description "Third-party payment processing service (Stripe, PayPal)"
        }

        emailSystem = softwareSystem "Email Service" "External" {
            description "Email service for sending notifications and receipts"
        }

        ecommerceSystem = softwareSystem "E-Commerce Platform" {
            description "The core e-commerce platform that manages products, orders, payments, and customers"
        }
        
        customer -> ecommerceSystem "Browses products, places orders, tracks shipments [HTTPS]"
        admin -> ecommerceSystem "Manages inventory, users, and system settings [HTTPS]"

        ecommerceSystem -> paymentGateway "Processes payments [HTTPS/API]"
        ecommerceSystem -> emailSystem "Sends order confirmations, shipping updates, receipts [SMTP/API]"
    }
    
    views {
        systemContext ecommerceSystem {
            include *
            autoLayout
            title "E-Commerce System - System Context"
        }
    }
}