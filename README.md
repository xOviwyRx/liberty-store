# Liberty Store

A modern e-commerce store with a fast, reactive interface. Browse a product catalog with rich-text descriptions and images, subscribe to out-of-stock items and get notified when they return, add products to a cart, and see stock update in real time.

![Liberty Store product catalog](docs/products_screenshot.png)

## Table of Contents

- [Tech Stack](#tech-stack)
- [Features](#features)
   - [Catalog & Product Management](#catalog--product-management)
   - [Back-in-Stock Alerts](#back-in-stock-alerts)
   - [Shopping Cart](#shopping-cart)
   - [Live Stock Updates](#live-stock-updates)
   - [Internationalization](#internationalization)
- [Getting Started](#getting-started)
- [Development](#development)
   - [Code Quality & Testing](#code-quality--testing)
   - [Deployment](#deployment)
- [Roadmap](#roadmap)

## Tech Stack

### Backend
- Ruby 3.4.3
- Ruby on Rails 8.0
- PostgreSQL

### Frontend
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Propshaft asset pipeline
- Import maps (ESM JavaScript)

### Authentication
- `has_secure_password` (bcrypt)
- Rails 8 authentication generator (session-based)

### Content & File Storage
- Action Text (rich-text product descriptions)
- Active Storage + `image_processing` (image uploads and variants)

### Background Jobs & Email
- Solid Queue
- Action Mailer

### Caching & Real-Time
- Solid Cache
- Solid Cable (WebSockets)

### Testing & Code Quality
- RSpec
- FactoryBot
- RuboCop (Rails Omakase)
- Brakeman

### DevOps & Deployment
- Docker
- Kamal

## Features

### Catalog & Product Management

A public catalog with authenticated management. Each product carries a name, an inventory count, a rich-text description (Action Text), and a featured image (Active Storage).

- Guests can browse all products without logging in.
- Authenticated users can create, edit, and delete products.
- Descriptions support embedded formatting and media via Action Text.
- Featured images are uploaded through Active Storage with on-the-fly variants.

### Back-in-Stock Alerts

When a product is out of stock, visitors can subscribe to be notified when it returns.

- The product page shows a subscription form while inventory is `0`.
- When inventory goes from `0` to a positive number, every subscriber is emailed.
- Emails are delivered from a background job (Solid Queue) so requests stay fast.
- Each email includes a secure, token-based unsubscribe link.

### Shopping Cart

> **(in progress)**

Add products to a cart and check out, with the cart updating live as you shop — the nav badge and cart panel update in a single response, without a full page reload.

### Live Stock Updates

> **(in progress)**

Stock status updates in real time. When an item is restocked, it becomes available to everyone currently viewing it without a page refresh.

### Internationalization

English and Spanish translations ship with the app.

- Append `?locale=es` to any URL to switch to Spanish.
- Translations are organized in `config/locales`.

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/xOviwyRx/liberty-store.git
   cd liberty-store
   ```

2. **Install dependencies**
   ```bash
   # System packages (Debian/Ubuntu): PostgreSQL client headers for the pg gem,
   # and libvips for Active Storage image variants
   sudo apt-get install -y libpq-dev libvips42t64
   bundle install
   ```

3. **Set up the database**

   Requires a running PostgreSQL. By default the app connects as `postgres` / `postgres` on `localhost:5432` — override with `DB_HOST`, `DB_USERNAME`, and `DB_PASSWORD` if your setup differs.
   ```bash
   bin/rails db:setup
   ```
   This creates the databases, loads the schema, and (in development) seeds an admin user and sample products.

4. **Start the app** (Rails server + Tailwind watcher)
   ```bash
   bin/dev
   ```
   Then open http://localhost:3000

5. **Log in** to manage the catalog using the development admin seeded in the previous step (credentials are in `db/seeds.rb`).

## Development

### Code Quality & Testing

```bash
bundle exec rspec  # model and request specs
bin/rubocop        # Rails Omakase style
bin/brakeman       # static security analysis
```

### Deployment

Configured for [Kamal](https://kamal-deploy.org):

```bash
export KAMAL_REGISTRY_PASSWORD=your-token
bin/kamal setup    # first deploy
bin/kamal deploy   # subsequent deploys
```

Configure SMTP for outgoing email in `config/environments/production.rb`.

## Roadmap

- [ ] Shopping cart with live Turbo Stream updates
- [ ] Live stock status via Turbo Stream broadcasting
- [ ] Product search, filtering, and pagination with Turbo Frames
- [ ] Orders and checkout
- [ ] GitHub Actions CI
- [ ] Deploy live

## License

[MIT](https://opensource.org/licenses/MIT)
