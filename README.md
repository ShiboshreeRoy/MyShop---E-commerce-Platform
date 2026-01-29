# MyShop - E-commerce Platform

MyShop is a comprehensive e-commerce platform built with Ruby on Rails, featuring a complete online store solution with product management, user authentication, and administrative capabilities.

## Features

- **User Management**: Secure authentication system with role-based access (customer, merchant, admin)
- **Product Catalog**: Complete product management with variants, pricing, and inventory tracking
- **Store Builder**: Merchants can create and customize their own online stores
- **Shopping Cart**: Full-featured cart system with add/remove/update functionality
- **Checkout Process**: Secure checkout with order management
- **Order Management**: Track and manage customer orders
- **Analytics Dashboard**: Insights and metrics for store performance
- **Multi-store Support**: Multiple vendors can operate individual stores
- **Image Handling**: Support for product images, store logos, and cover images
- **Responsive Design**: Mobile-friendly interface using Tailwind CSS

## Tech Stack

- **Backend**: Ruby on Rails
- **Database**: SQLite
- **Authentication**: Devise
- **Admin Interface**: Rails Admin
- **Frontend Framework**: Tailwind CSS
- **JavaScript**: Stimulus & Turbo
- **Asset Pipeline**: Importmaps

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ShiboshreeRoy/MyShop---E-commerce-Platform.git
cd MyShop---E-commerce-Platform
```

2. Install dependencies:
```bash
bundle install
```

3. Install JavaScript dependencies:
```bash
./bin/importmap install
```

4. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. Start the server:
```bash
rails server
```

6. Visit `http://localhost:3000` in your browser

## Getting Started

### For Customers
1. Register for an account or log in
2. Browse products and stores
3. Add items to your cart
4. Complete checkout to place orders

### For Merchants
1. Register as a merchant user
2. Create your store with the store builder
3. Add products with images and variants
4. Manage inventory and orders
5. View analytics for your store

### For Administrators
1. Access the admin panel at `/admin`
2. Manage users, products, and orders
3. Monitor platform-wide analytics

## Key Components

### Models
- **User**: Handles authentication and roles
- **Store**: Represents individual vendor shops
- **Product**: Core product model with variants
- **Order**: Order management system
- **Cart**: Shopping cart functionality
- **Review**: Product reviews and ratings

### Controllers
- **Users**: Authentication and profile management
- **Stores**: Store creation and management
- **Products**: Product catalog operations
- **Orders**: Order processing and management
- **Cart**: Shopping cart functionality
- **Dashboard**: User-specific dashboards

### Views
- **Responsive UI**: Built with Tailwind CSS
- **Modular Components**: Shared partials for consistency
- **Interactive Elements**: Stimulus-powered dynamic features
- **Flash Messages**: Toast notifications for user feedback

## Customization

### Styling
The application uses Tailwind CSS for styling. You can customize the appearance by modifying:
- `app/assets/stylesheets/application.tailwind.css`
- Component classes in the view files

### Functionality
Extend the platform by:
- Adding new models and controllers
- Enhancing the product variant system
- Integrating payment gateways (Stripe, PayPal)
- Adding shipping calculators
- Implementing advanced analytics

## Deployment

For production deployment:
1. Update the database configuration for PostgreSQL or MySQL
2. Configure environment variables for production
3. Precompile assets: `RAILS_ENV=production bundle exec rake assets:precompile`
4. Deploy to your preferred hosting platform (Heroku, AWS, etc.)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is available as open source under the terms of the MIT License.

## Support

If you encounter any issues or have questions, please create an issue in the repository or contact the development team.

---

Built with ❤️ using Ruby on Rails