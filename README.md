# Rails 8 Store

A modern e-commerce web application built with Ruby on Rails 8, demonstrating the latest Rails features and best practices. This project showcases a complete online store with product management, user authentication, rich text editing, file uploads, email notifications, and internationalization.

## Features

### 🛍️ Product Management
- **CRUD Operations**: Create, read, update, and delete products
- **Rich Text Descriptions**: Powered by Action Text with embedded media support
- **File Uploads**: Featured image uploads using Active Storage
- **Inventory Tracking**: Real-time stock management with validation
- **Responsive Design**: Clean, modern CSS with mobile-friendly layouts

### 🔐 Authentication & Authorization
- **User Authentication**: Secure login/logout system using Rails 8 authentication generator
- **Protected Routes**: Authenticated-only access for product management
- **Guest Access**: Public product browsing for unauthenticated users
- **Password Security**: BCrypt encryption for secure password storage

### 📧 Email Notifications
- **Stock Alerts**: Automatic email notifications when products come back in stock
- **Subscriber Management**: Users can subscribe to out-of-stock products
- **Unsubscribe Links**: Secure token-based unsubscribe functionality
- **HTML & Text Emails**: Professional email templates in both formats

### 🌍 Internationalization
- **Multi-language Support**: English and Spanish translations included
- **Locale Switching**: URL-based locale parameter support
- **Organized Translations**: Structured locale files with relative lookups

### ⚡ Performance & Optimization
- **Caching**: Solid Cache for improved page load times
- **Background Jobs**: Solid Queue for asynchronous email processing
- **Asset Pipeline**: Propshaft for efficient asset management
- **Import Maps**: Modern JavaScript without build steps

### 🎨 Modern Frontend
- **Hotwire Integration**: Turbo and Stimulus for reactive user interfaces
- **No Build Steps**: Import maps for JavaScript dependencies
- **Progressive Enhancement**: Works without JavaScript, enhanced with it

## Technology Stack

- **Backend**: Ruby on Rails 8.0+
- **Database**: SQLite (development), PostgreSQL (production recommended)
- **Authentication**: Rails 8 built-in authentication
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Vanilla CSS with modern flexbox layouts
- **Email**: Action Mailer with background job processing
- **File Storage**: Active Storage for image uploads
- **Caching**: Solid Cache (database-backed)
- **Background Jobs**: Solid Queue
- **Deployment**: Kamal with Docker containerization

## Prerequisites

- Ruby 3.2 or newer
- Rails 8.0.0 or newer
- Node.js (for asset compilation)
- Git

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/rails8-store.git
   cd rails8-store
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup the database**
   ```bash
   bin/rails db:migrate
   ```

4. **Install Action Text**
   ```bash
   bin/rails action_text:install
   bin/rails db:migrate
   ```

5. **Create a user account**
   ```bash
   bin/rails console
   # In the console:
   User.create!(email_address: "admin@example.com", password: "password123", password_confirmation: "password123")
   ```

6. **Start the server**
   ```bash
   bin/rails server
   ```

7. **Visit the application**
   Open http://localhost:3000 in your browser

## Usage

### Managing Products
1. **Login** with your user credentials
2. **Create Products**: Click "New product" to add products with names, descriptions, and images
3. **Edit Products**: Update product information and inventory counts
4. **Delete Products**: Remove products from the store

### Customer Experience
1. **Browse Products**: View all available products without authentication
2. **Subscribe to Notifications**: Get notified when out-of-stock items return
3. **Multilingual Support**: Add `?locale=es` to URLs for Spanish translation

### Email Notifications
- Products with 0 inventory show subscription forms
- When inventory is updated from 0 to a positive number, all subscribers receive email notifications
- Emails include unsubscribe links for easy opt-out

## Configuration

### Environment Variables
```bash
# For production deployment with Kamal
KAMAL_REGISTRY_PASSWORD=your-docker-hub-token
```

### Email Configuration
Configure your email settings in `config/environments/production.rb`:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'yourdomain.com',
  user_name: 'your-email@gmail.com',
  password: 'your-app-password',
  authentication: 'plain',
  enable_starttls_auto: true
}
```

### Internationalization
Add new locales by creating files in `config/locales/`:
- `config/locales/fr.yml` for French
- `config/locales/de.yml` for German

## Testing

Run the test suite:
```bash
# Run all tests
bin/rails test

# Run specific test file
bin/rails test test/models/product_test.rb

# Run with coverage
bin/rails test --verbose
```

## Code Quality

### Linting
```bash
# Check code formatting
bin/rubocop

# Auto-fix formatting issues
bin/rubocop -a
```

### Security Analysis
```bash
# Run security analysis
bin/brakeman
```

## Deployment

This application is configured for deployment using Kamal:

1. **Setup your server** (Ubuntu LTS with 1GB+ RAM)
2. **Configure Docker Hub**:
    - Create account and repository
    - Generate access token
3. **Update deployment configuration** in `config/deploy.yml`
4. **Deploy**:
   ```bash
   export KAMAL_REGISTRY_PASSWORD=your-token
   bin/kamal setup  # First deployment
   bin/kamal deploy # Subsequent deployments
   ```

### Production Setup
After deployment, create an admin user:
```bash
bin/kamal console
# In production console:
User.create!(email_address: "admin@yourdomain.com", password: "secure-password", password_confirmation: "secure-password")
```

## Architecture

### Models
- **Product**: Core product model with validations and associations
- **User**: Authentication model with secure password handling
- **Subscriber**: Email subscription model for stock notifications
- **Product::Notifications**: Concern for handling email notifications

### Controllers
- **ProductsController**: RESTful product management
- **SubscribersController**: Email subscription handling
- **UnsubscribesController**: Secure unsubscribe functionality
- **ApplicationController**: Base controller with authentication

### Key Features Implementation
- **Rich Text**: Action Text integration for product descriptions
- **File Uploads**: Active Storage for product images
- **Background Jobs**: Solid Queue for email processing
- **Caching**: Fragment caching for improved performance
- **Security**: CSRF protection, strong parameters, secure tokens

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Best Practices Demonstrated

- **RESTful Design**: Standard Rails conventions and routing
- **Security First**: Authentication, authorization, and input validation
- **Test Coverage**: Model and mailer tests with fixtures
- **Code Organization**: Concerns for shared functionality
- **Performance**: Caching and background job processing
- **Accessibility**: Semantic HTML and proper form labeling
- **Internationalization**: Multi-language support from the start

## Learning Resources

This project demonstrates concepts from:
- [Rails Guides](https://guides.rubyonrails.org/)
- [Ruby on Rails Tutorial](https://www.railstutorial.org/)
- [Rails 8 Release Notes](https://guides.rubyonrails.org/8_0_release_notes.html)

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Support

If you encounter any issues or have questions:
1. Check the [Rails Guides](https://guides.rubyonrails.org/)
2. Search existing [GitHub Issues](https://github.com/rails/rails/issues)
3. Create a new issue with detailed information
