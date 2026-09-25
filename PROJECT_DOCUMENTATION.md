# Instafoods — Complete Project Documentation

> **Purpose:** Full snapshot of the Instafoods project so any developer or AI model can understand the current state, make changes, and integrate the backend correctly.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technology Stack](#2-technology-stack)
3. [Project Structure](#3-project-structure)
4. [Design System](#4-design-system)
5. [Frontend Pages — Detailed Reference](#5-frontend-pages--detailed-reference)
6. [Restaurant Data (Source of Truth)](#6-restaurant-data-source-of-truth)
7. [Menu Items Per Restaurant](#7-menu-items-per-restaurant)
8. [Backend — Java Models](#8-backend--java-models)
9. [Backend — DAO Interfaces](#9-backend--dao-interfaces)
10. [Backend — DAO Implementations](#10-backend--dao-implementations)
11. [Frontend-Backend Integration Guide](#11-frontend-backend-integration-guide)
12. [Cart and Order Flow](#12-cart-and-order-flow)
13. [LocalStorage Data Contracts](#13-localstorage-data-contracts)
14. [Images Reference](#14-images-reference)
15. [What Still Needs to Be Built](#15-what-still-needs-to-be-built)
16. [Key Notes for Any Developer or AI Model](#16-key-notes-for-any-developer-or-ai-model)

---

## 1. Project Overview

- **Project Name:** Instafoods
- **Type:** Food delivery web application
- **City/Region:** Bengaluru (Bangalore), India
- **Theme:** Dark mode, neon-accent lime (#caff00), premium modern design
- **Currency:** Indian Rupee (INR)

### Core User Flow

```
Landing Page → Restaurants Page → Menu Page → Cart → Checkout → Order Confirmation → Insta-Tracker
```

---

## 2. Technology Stack

| Layer       | Technology                            |
|-------------|---------------------------------------|
| Frontend    | HTML5, CSS3 (Vanilla), JavaScript (Vanilla) |
| Icons       | Font Awesome 6.4.0 (CDN)              |
| Backend     | Java (Jakarta EE / Servlet)           |
| Database    | MySQL (JDBC connection)               |
| Server      | Apache Tomcat (Eclipse-managed)       |
| Build Tool  | Maven (Eclipse project)               |
| IDE         | Eclipse                               |

---

## 3. Project Structure

```
instafoo/
├── src/
│   └── main/
│       ├── java/com/instafoo/
│       │   ├── Model/
│       │   │   ├── User.java
│       │   │   ├── Restaurant.java
│       │   │   ├── Menu.java
│       │   │   ├── OrderTable.java
│       │   │   └── OrderItem.java
│       │   ├── connection/
│       │   │   └── DBConnection.java
│       │   ├── dao/
│       │   │   ├── UserDao.java
│       │   │   ├── RestaurantDao.java
│       │   │   ├── MenuDao.java
│       │   │   ├── OrderTableDao.java
│       │   │   └── OrderItemDao.java
│       │   └── daoImp/
│       │       ├── UserDaoImp.java
│       │       ├── RestaurantDaoImp.java
│       │       ├── MenuDaoImp.java
│       │       ├── OrderTableDaoImp.java
│       │       └── OrderItemDaoImp.java
│       └── webapp/
│           ├── images/
│           │   ├── rest_south_indian.png
│           │   ├── rest_modern.png
│           │   ├── rest_cafe.png
│           │   ├── rest_biryani.png
│           │   ├── rest_asian.png
│           │   ├── rest_italian.png
│           │   └── rest_indian.png
│           ├── WEB-INF/web.xml
│           ├── styles.css            ← Global design system
│           ├── landing.html          ← Homepage
│           ├── restaurants.html      ← All restaurants + filter
│           ├── menu.html             ← Full menu grouped by restaurant
│           ├── cart.html             ← Shopping cart
│           ├── checkout.html         ← Checkout form
│           ├── order-confirmation.html  ← Success page
│           ├── ordered-items.html    ← Insta-Tracker
│           ├── home.html             ← Post-login home
│           ├── login.html            ← Login
│           └── signup.html           ← Sign up
└── PROJECT_DOCUMENTATION.md          ← THIS FILE
```

---

## 4. Design System

All global styles are in **styles.css**. Link it in every page:
```html
<link rel="stylesheet" href="styles.css">
```

### CSS Variables (in :root)

```
--primary:        #caff00     Neon lime accent
--bg-dark:        #080808     Page background
--bg-card:        #111111     Card background
--bg-card-hover:  #161616     Card hover state
--border:         #222222     Border color
--text-primary:   #ffffff
--text-muted:     #888888
--font-heading:   Space Grotesk (bold heading font)
--transition:     all 0.3s ease
```

### Key Reusable Classes

| Class              | Purpose                                   |
|--------------------|-------------------------------------------|
| .navbar            | Fixed top navigation bar                  |
| .btn.btn-primary   | Neon lime filled button                   |
| .btn.btn-outline   | Transparent bordered button               |
| .btn.btn-secondary | Muted secondary button                    |
| .hero              | Full-screen hero section                  |
| .section           | Standard page section with padding        |
| .section-header    | Centered title + subtitle block           |
| .metric-card       | Stats card (icon + number + label)        |
| .food-card         | Menu item card                            |
| .food-img          | 200px image block inside food-card        |
| .food-badge        | Top-left badge on food-img                |
| .food-card-footer  | Price + button row at card bottom         |
| .food-price        | Price text inside food-card-footer        |
| .cta-section       | Bottom call-to-action section             |
| .highlight         | Neon lime colored text span               |

### Animations

- `fadeSlideUp` — cards fade and slide up on load (staggered per card)
- `pulse-dot` — "Open" status dot pulses continuously
- `shimmer` — sweep glow effect on card hover

---

## 5. Frontend Pages — Detailed Reference

### 5.1 landing.html — Homepage

**Purpose:** Marketing landing page / entry point.

**Navbar links:** Restaurants, Full Menu, Insta-Tracker, Cart, Sign In, Join Instafoods

**Sections:**
1. Hero — "Outrun your cravings." headline, two CTAs, two phone mockups
2. Featured Restaurants — 6 cards using `.feat-card` class (defined in page-level style block)
3. CTA Banner — "Join The Club" signup prompt
4. Footer

**Featured restaurants (6 of 9) shown on landing page:**

| Card | Restaurant         | Link                    |
|------|--------------------|-------------------------|
| 1    | Nagarjuna Restaurant | menu.html?restaurant=1 |
| 2    | Toit Brewpub         | menu.html?restaurant=2 |
| 3    | Brahmin's Coffee Bar | menu.html?restaurant=3 |
| 4    | Dum Pukht Jolly Nabobs | menu.html?restaurant=5 |
| 5    | Shiro                | menu.html?restaurant=6 |
| 6    | The Permit Room      | menu.html?restaurant=9 |

**Landing page card CSS class:** `.feat-card` — defined in inline `<style>` block within landing.html. Has these features:
- `.feat-img` with `<img>` (real restaurant photo), zoom on hover
- `.feat-badge-open` with pulsing dot
- `.feat-img-name` — name overlaid on image
- `.feat-cuisine` — neon-styled cuisine tag
- `.feat-meta` with rating, delivery time, and "View Menu" button

---

### 5.2 restaurants.html — All Restaurants

**Purpose:** Browse and filter all 9 partner restaurants.

**Filter chip IDs:** `filter-all`, `filter-south-indian`, `filter-north-indian`, `filter-italian`, `filter-asian`, `filter-cafe`, `filter-open`

**Data attributes on each restaurant card:**
```html
data-cuisine="South Indian"     <!-- matches filter values exactly -->
data-active="true"              <!-- "true" = open, "false" = closed -->
data-name="Restaurant Name"
data-delivery-time="20"
data-address="Full address, Bengaluru"
data-rating="4.8"
data-image="images/rest_xxx.png"
```

**Filter cuisine values:** `South Indian`, `North Indian`, `Italian`, `Asian`, `Cafe`

**JS function:** `filterRestaurants(type)` — uses `CHIP_ID_MAP` object mapping cuisine values to chip element IDs.

**"View Menu" link:** `menu.html?restaurant=N`

---

### 5.3 menu.html — Full Menu

**Purpose:** All menu items grouped by restaurant.

**Restaurant Jump Nav:** Pill chips at top to scroll to each restaurant section.

**Filter categories (data-category values on .food-card):**
- `south-indian` — Nagarjuna, Brahmin's, The Permit Room
- `cafe` — Toit Brewpub, Smoke House Deli
- `north-indian` — Dum Pukht Jolly Nabobs
- `asian` — Shiro, Fatty Bao
- `italian` — Trattoria

**Restaurant section IDs and query params:**
```
#nagarjuna   restaurant=1
#toit        restaurant=2
#brahmins    restaurant=3
#smokehouse  restaurant=4
#dumpukht    restaurant=5
#shiro       restaurant=6
#fattybao    restaurant=7
#trattoria   restaurant=8
#permitroom  restaurant=9
```

**URL query param `?restaurant=N`** — page auto-scrolls to the matching restaurant section on load.

**Prices:** All in INR (Rs symbol).

**JS function:** `filterMenu(type, clickedChip)` — hides/shows food-cards AND hides entire restaurant groups with no visible cards.

---

### 5.4 cart.html — Shopping Cart

**Data source:** localStorage key `instafoods_cart` (array of objects)

**Features:**
- Cart items rendered dynamically from localStorage
- Quantity +/- buttons, remove button
- Subtotal + delivery fee (Rs 40) + grand total
- "Proceed to Checkout" → checkout.html
- Empty cart state

---

### 5.5 checkout.html — Checkout

**Form fields:** fullName, phone, address, city, pincode, paymentMode (online|upi), upiId (conditional)

**On submit (submitOrder function):**
1. Reads form values
2. Saves to localStorage key `instafoods_last_order` (see Section 13)
3. Clears `instafoods_cart`
4. Redirects to order-confirmation.html

---

### 5.6 order-confirmation.html — Order Success Page

**Features:**
- Animated success checkmark icon
- "Order Placed Successfully!" heading
- Order summary from localStorage `instafoods_last_order`
- Buttons: "Track Your Order" (→ ordered-items.html) and "Go to Home" (→ landing.html)

---

### 5.7 ordered-items.html — Insta-Tracker

**Navbar label:** "Insta-Tracker"

**Features:**
- Order items list from localStorage `instafoods_last_order`
- Delivery address, payment mode display
- Order status with progress bar
- Static statuses: "Preparing" / "Out for Delivery" / "Delivered"

---

### 5.8 login.html

**Form fields:** email, password  
**Backend endpoint needed:** POST /LoginServlet  
**On success:** redirect to home.html or landing.html

---

### 5.9 signup.html

**Form fields:** username, email, password, confirmPassword, address  
**Backend endpoint needed:** POST /RegisterServlet

---

### 5.10 styles.css — CRITICAL: DO NOT MODIFY CORE VARIABLES

Add page-specific styles in `<style>` blocks within each HTML file rather than modifying styles.css to avoid breaking all pages.

---

## 6. Restaurant Data (Source of Truth)

All 9 restaurants. This is the authoritative data for both frontend and database population.

| ID | name | cuisine_type | delivery_time (min) | rating | is_active | image_path |
|----|------|-------------|-------------------|--------|-----------|-----------|
| 1  | Nagarjuna Restaurant | South Indian | 20 | 4.8 | true | images/rest_south_indian.png |
| 2  | Toit Brewpub | Cafe | 25 | 4.7 | true | images/rest_modern.png |
| 3  | Brahmin's Coffee Bar | South Indian | 15 | 4.9 | true | images/rest_south_indian.png |
| 4  | Smoke House Deli | Cafe | 30 | 4.6 | true | images/rest_cafe.png |
| 5  | Dum Pukht Jolly Nabobs | North Indian | 35 | 4.8 | true | images/rest_biryani.png |
| 6  | Shiro | Asian | 28 | 4.7 | true | images/rest_asian.png |
| 7  | Fatty Bao | Asian | 22 | 4.6 | true | images/rest_asian.png |
| 8  | Trattoria | Italian | 32 | 4.5 | FALSE | images/rest_italian.png |
| 9  | The Permit Room | South Indian | 18 | 4.7 | true | images/rest_indian.png |

**Addresses:**
1. Residency Road, MG Road, Bengaluru
2. 100 Feet Rd, Indiranagar, Bengaluru
3. Shankarapuram, Basavanagudi, Bengaluru
4. 3rd Cross Rd, Koramangala, Bengaluru
5. ITC Windsor, Golf Course Rd, Bengaluru
6. UB City Mall, Vittal Mallya Rd, Bengaluru
7. 12th Main Rd, Indiranagar, Bengaluru
8. The Oberoi, MG Road, Bengaluru
9. Church Street, Bengaluru Central

### SQL INSERT — Restaurant Table

```sql
INSERT INTO restaurant (restaurant_id, name, cuisine_type, delivery_time, address, rating, is_active, image_path) VALUES
(1, 'Nagarjuna Restaurant', 'South Indian', 20, 'Residency Road, MG Road, Bengaluru', 4.8, TRUE, 'images/rest_south_indian.png'),
(2, 'Toit Brewpub', 'Cafe', 25, '100 Feet Rd, Indiranagar, Bengaluru', 4.7, TRUE, 'images/rest_modern.png'),
(3, 'Brahmin Coffee Bar', 'South Indian', 15, 'Shankarapuram, Basavanagudi, Bengaluru', 4.9, TRUE, 'images/rest_south_indian.png'),
(4, 'Smoke House Deli', 'Cafe', 30, '3rd Cross Rd, Koramangala, Bengaluru', 4.6, TRUE, 'images/rest_cafe.png'),
(5, 'Dum Pukht Jolly Nabobs', 'North Indian', 35, 'ITC Windsor, Golf Course Rd, Bengaluru', 4.8, TRUE, 'images/rest_biryani.png'),
(6, 'Shiro', 'Asian', 28, 'UB City Mall, Vittal Mallya Rd, Bengaluru', 4.7, TRUE, 'images/rest_asian.png'),
(7, 'Fatty Bao', 'Asian', 22, '12th Main Rd, Indiranagar, Bengaluru', 4.6, TRUE, 'images/rest_asian.png'),
(8, 'Trattoria', 'Italian', 32, 'The Oberoi, MG Road, Bengaluru', 4.5, FALSE, 'images/rest_italian.png'),
(9, 'The Permit Room', 'South Indian', 18, 'Church Street, Bengaluru Central', 4.7, TRUE, 'images/rest_indian.png');
```

---

## 7. Menu Items Per Restaurant

27 total items (3 per restaurant). Prices in INR.

### SQL INSERT — Menu Table

```sql
INSERT INTO menu (restaurant_id, item_name, description, price, is_available, image_path) VALUES
-- Nagarjuna (id=1)
(1, 'Nagarjuna Chicken Curry', 'Slow-cooked Andhra-style chicken, gongura leaves, steamed rice, pappad.', 320, TRUE, NULL),
(1, 'Pesarattu and Upma', 'Crispy green moong dosa stuffed with semolina upma, ginger chutney, sambar.', 180, TRUE, NULL),
(1, 'Gongura Mutton', 'Tender mutton slow-cooked with sorrel leaves, red chilies, Andhra masala, jowar roti.', 420, TRUE, NULL),
-- Toit Brewpub (id=2)
(2, 'Toit Brewpub Burger', 'Double smash beef patty, aged cheddar, caramelised onion, Toit BBQ sauce, brioche bun.', 650, TRUE, NULL),
(2, 'Buttermilk Pancake Stack', 'Fluffy golden pancakes, fresh berry compote, maple syrup, whipped mascarpone, candied walnuts.', 420, TRUE, NULL),
(2, 'Truffle Parmesan Fries', 'Double-fried Belgian fries, black truffle oil, shaved parmesan, chives, garlic aioli.', 350, TRUE, NULL),
-- Brahmin Coffee Bar (id=3)
(3, 'Idli Vada Combo', 'Three steamed idlis, one crispy medu vada, sambar, coconut chutney, filter coffee.', 120, TRUE, NULL),
(3, 'Filter Coffee', 'Traditional Bangalore filter coffee, Arabica-Robusta blend, dabaara-tumbler set.', 40, TRUE, NULL),
(3, 'Rava Kesari and Dosa', 'Crispy masala dosa, potato filling, rava kesari, sambar, chutneys.', 160, TRUE, NULL),
-- Smoke House Deli (id=4)
(4, 'Smoked Chicken Club', 'Applewood-smoked chicken, crispy bacon, Dijon aioli, iceberg, heirloom tomato, sourdough toast.', 580, TRUE, NULL),
(4, 'Quinoa Halloumi Bowl', 'Red quinoa, pan-seared halloumi, roasted cherry tomatoes, cucumber ribbons, lemon-herb dressing.', 520, TRUE, NULL),
(4, 'Full English Breakfast', 'Sausages, back bacon, poached eggs, grilled mushrooms, baked beans, grilled tomato, buttered toast.', 720, FALSE, NULL),
-- Dum Pukht Jolly Nabobs (id=5)
(5, 'Gosht Dum Biryani', 'Lucknowi slow-dum biryani, aged Basmati, marinated lamb, saffron, rose water, fried onions.', 980, TRUE, NULL),
(5, 'Galouti Kebab', 'Minced lamb kebabs with 160 spices, griddle-seared, warqi paratha, mint chutney.', 780, TRUE, NULL),
(5, 'Murgh Makhani', 'Tandoori chicken in velvety tomato-cream sauce, cardamom, butter, kasuri methi, butter naan.', 680, TRUE, NULL),
-- Shiro (id=6)
(6, 'Wagyu Sushi Platter', 'A5 Wagyu nigiri, spicy tuna maki, salmon aburi, tiger prawn tempura roll.', 1850, TRUE, NULL),
(6, 'Black Garlic Tonkotsu Ramen', '12-hour pork bone broth, chashu pork belly, soft-boiled egg, nori, bamboo shoots.', 920, TRUE, NULL),
(6, 'Peking Duck with Pancakes', 'Whole roasted Peking duck, thin steamed pancakes, hoisin, cucumber, spring onion.', 2400, FALSE, NULL),
-- Fatty Bao (id=7)
(7, 'Crispy Prawn Har Gow', 'Steamed translucent dumplings, fresh king prawns, bamboo shoots, sesame oil, XO chilli sauce.', 480, TRUE, NULL),
(7, 'Singapore Chilli Crab Noodles', 'Vermicelli in Singapore chilli crab sauce, egg floss, crispy garlic, spring onion oil.', 720, TRUE, NULL),
(7, 'Thai Green Curry Bowl', 'Coconut green curry, seasonal vegetables, kaffir lime, lemongrass, jasmine rice, crispy tofu.', 560, TRUE, NULL),
-- Trattoria (id=8)
(8, 'Wild Mushroom Tagliatelle', 'Hand-rolled tagliatelle, porcini ragù, parmesan cream, fresh thyme, black truffle shavings.', 880, TRUE, NULL),
(8, 'Diavola Inferno Pizza', 'San Marzano tomato base, nduja, fior di latte mozzarella, Calabrian chilli oil, fresh basil.', 920, TRUE, NULL),
(8, 'Burrata Caprese Salad', 'Fresh burrata, heirloom tomatoes, Sicilian basil oil, aged balsamic glaze, Maldon sea salt.', 680, TRUE, NULL),
-- The Permit Room (id=9)
(9, 'Crispy Prawn Koliwada', 'Coastal fried prawns in spiced besan batter, raw mango pickle relish, curry leaf aioli.', 480, TRUE, NULL),
(9, 'Ghee Roast Chicken Dosa Roll', 'Mangalorean ghee-roast chicken, crisp dosa roll, tamarind chutney, fried onions.', 380, TRUE, NULL),
(9, 'Tender Coconut Payasam', 'Coconut milk payasam, tender coconut pieces, jaggery, cardamom, cashews — served chilled.', 220, TRUE, NULL);
```

---

## 8. Backend — Java Models

### 8.1 Restaurant.java — com.instafoo.Model.Restaurant

```
Fields:
  int     restaurant_id
  String  name
  String  cuisine_type     ("South Indian", "Cafe", "North Indian", "Asian", "Italian")
  int     delivery_time    (in minutes)
  String  address
  double  rating           (e.g. 4.8)
  Boolean is_active        (true = open, false = closed)
  String  image_path       (e.g. "images/rest_south_indian.png")

Constructors:
  Restaurant()
  Restaurant(name, cuisine_type, delivery_time, address, rating, is_active, image_path)
  Restaurant(restaurant_id, name, cuisine_type, delivery_time, address, rating, is_active, image_path)
```

### 8.2 Menu.java — com.instafoo.Model.Menu

```
Fields:
  int     menuId
  int     restaurantId     (FK to restaurant.restaurant_id)
  String  itemName
  String  description
  double  price            (in INR)
  boolean isAvailable
  String  imagePath        (can be null)
```

### 8.3 OrderTable.java — com.instafoo.Model.OrderTable

```
Fields:
  int       orderId
  int       userId           (FK to user.user_id)
  int       restaurantId     (FK to restaurant.restaurant_id)
  Timestamp orderDate
  double    totalAmount      (in INR)
  String    status           ("Pending", "Preparing", "Out for Delivery", "Delivered")
  String    paymentMode      ("online" or "upi")
```

### 8.4 OrderItem.java — com.instafoo.Model.OrderItem

```
Fields:
  int    orderItemId
  int    orderId       (FK to order_table.order_id)
  int    menuId        (FK to menu.menu_id)
  int    quantity
  double subtotal      (quantity x price)
```

### 8.5 User.java — com.instafoo.Model.User

```
Fields:
  int       user_id
  String    username
  String    password
  String    email
  String    role         ("customer", "admin")
  String    address
  Timestamp logout
  Timestamp create
```

---

## 9. Backend — DAO Interfaces

Located in com.instafoo.dao:

### RestaurantDao.java

```java
List<Restaurant> getAllRestaurants();
Restaurant getRestaurantById(int id);
List<Restaurant> getRestaurantsByCuisine(String cuisineType);
List<Restaurant> getActiveRestaurants();
boolean addRestaurant(Restaurant r);
boolean updateRestaurant(Restaurant r);
```

### MenuDao.java

```java
List<Menu> getAllMenuItems();
List<Menu> getMenuByRestaurantId(int restaurantId);
Menu getMenuItemById(int menuId);
boolean addMenuItem(Menu m);
boolean updateMenuItem(Menu m);
```

### OrderTableDao.java

```java
boolean placeOrder(OrderTable order);
List<OrderTable> getOrdersByUserId(int userId);
OrderTable getOrderById(int orderId);
boolean updateOrderStatus(int orderId, String status);
```

### OrderItemDao.java

```java
boolean addOrderItem(OrderItem item);
List<OrderItem> getOrderItemsByOrderId(int orderId);
```

### UserDao.java

```java
boolean registerUser(User user);
User loginUser(String email, String password);
User getUserById(int userId);
boolean updateUser(User user);
```

---

## 10. Backend — DAO Implementations

Located in com.instafoo.daoImp. Each class implements the corresponding DAO interface using JDBC via DBConnection.java.

DBConnection.java returns a java.sql.Connection to MySQL.
Update MySQL URL, username, and password in DBConnection.java before running.

---

## 11. Frontend-Backend Integration Guide

### Servlet URL Mapping

| Frontend Action        | Method | Servlet URL             | Request Data                         | Response         |
|------------------------|--------|-------------------------|--------------------------------------|------------------|
| Login form submit      | POST   | /LoginServlet           | email, password                      | redirect/error   |
| Signup form submit     | POST   | /RegisterServlet        | username, email, password, address   | redirect/error   |
| Load restaurants page  | GET    | /RestaurantServlet      | (none)                               | JSON array       |
| Load menu page         | GET    | /MenuServlet?restaurantId=N | restaurantId                    | JSON array       |
| Add to cart            | POST   | /CartServlet            | menuId, quantity, userId             | success/error    |
| Place order            | POST   | /OrderServlet           | address, paymentMode, items, total   | orderId          |
| Get order status       | GET    | /OrderServlet?orderId=N | orderId                              | OrderTable JSON  |

### Step 1: Dynamic Restaurants (restaurants.html)

Replace static HTML cards with this JS:

```javascript
fetch('/RestaurantServlet')
  .then(res => res.json())
  .then(restaurants => {
    const grid = document.getElementById('restaurant-grid');
    grid.innerHTML = '';
    restaurants.forEach(r => {
      grid.innerHTML += buildRestaurantCard(r);
    });
    // Re-attach filter after rendering
  });

function buildRestaurantCard(r) {
  return `
    <a href="menu.html?restaurant=${r.restaurant_id}" class="restaurant-card"
       data-cuisine="${r.cuisine_type}" data-active="${r.is_active}">
      <div class="restaurant-img">
        <img src="${r.image_path}" alt="${r.name}">
        <span class="feat-badge-open"><span class="dot"></span>${r.is_active ? 'Open' : 'Closed'}</span>
        <div class="img-name-overlay">${r.name}</div>
      </div>
      <div class="restaurant-info">
        <span class="restaurant-cuisine-tag">${r.cuisine_type}</span>
        <div class="restaurant-name">${r.name}</div>
        <div class="restaurant-address"><i class="fa-solid fa-location-dot"></i>${r.address}</div>
        <div class="restaurant-meta">
          <div class="meta-group">
            <div class="meta-item"><strong>${r.rating}</strong></div>
            <div class="meta-item"><strong>${r.delivery_time} mins</strong></div>
          </div>
          <a href="menu.html?restaurant=${r.restaurant_id}" class="view-menu-btn">
            View Menu <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
      </div>
    </a>`;
}
```

### Step 2: Dynamic Menu (menu.html)

```javascript
const params = new URLSearchParams(window.location.search);
const restaurantId = params.get('restaurant');
const url = restaurantId ? `/MenuServlet?restaurantId=${restaurantId}` : '/MenuServlet';
fetch(url).then(res => res.json()).then(items => renderMenu(items));
```

### Step 3: Add to Cart via Servlet

```javascript
function addToCart(menuId, quantity) {
  fetch('/CartServlet', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({ menuId, quantity, userId: getLoggedInUserId() })
  }).then(res => res.json()).then(data => {
    if (data.success) updateCartCount();
  });
}
```

### Step 4: Place Order via Servlet

```javascript
fetch('/OrderServlet', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    userId: getLoggedInUserId(),
    restaurantId: getCartRestaurantId(),
    address: document.getElementById('address').value,
    paymentMode: selectedPaymentMode,
    upiId: document.getElementById('upiId')?.value || '',
    items: getCartItems(),
    totalAmount: getCartTotal()
  })
}).then(res => res.json()).then(data => {
  localStorage.setItem('instafoods_last_order_id', data.orderId);
  window.location.href = 'order-confirmation.html';
});
```

---

## 12. Cart and Order Flow

```
menu.html
  "Add to Cart" button clicked
    → localStorage["instafoods_cart"] updated (see Section 13)

cart.html
  reads localStorage, renders items, calculates total
  "Proceed to Checkout" → checkout.html

checkout.html
  user fills address + payment mode
  submitOrder():
    [Frontend] → saves to localStorage["instafoods_last_order"]
    [Backend]  → POST /OrderServlet → returns orderId
    → redirects to order-confirmation.html

order-confirmation.html
  shows success message, order summary from localStorage

ordered-items.html (Insta-Tracker)
  shows full order with tracking status
  [Backend integration] → GET /OrderServlet?orderId=N
```

---

## 13. LocalStorage Data Contracts

### instafoods_cart (Array)

```json
[
  {
    "id": "menu-item-unique-id",
    "name": "Nagarjuna Chicken Curry",
    "price": 320,
    "quantity": 2,
    "restaurant": "Nagarjuna Restaurant",
    "restaurantId": 1
  }
]
```

### instafoods_last_order (Object)

```json
{
  "fullName": "Rajat",
  "phone": "9876543210",
  "address": "123, 4th Cross, Koramangala",
  "city": "Bengaluru",
  "pincode": "560034",
  "paymentMode": "upi",
  "upiId": "rajat@oksbi",
  "cartItems": [],
  "totalAmount": 1460,
  "orderDate": "2026-06-16T07:00:00.000Z",
  "orderId": null
}
```

---

## 14. Images Reference

All images are in src/main/webapp/images/ (AI-generated restaurant interior photos).

| File                    | Style                      | Used By                         |
|-------------------------|----------------------------|---------------------------------|
| rest_south_indian.png   | Traditional South Indian   | Nagarjuna, Brahmin's Coffee Bar |
| rest_modern.png         | Rooftop / Modern cafe      | Toit Brewpub                    |
| rest_cafe.png           | Industrial cafe            | Smoke House Deli                |
| rest_biryani.png        | Mughlai / North Indian     | Dum Pukht Jolly Nabobs          |
| rest_asian.png          | Japanese / Pan-Asian       | Shiro, Fatty Bao                |
| rest_italian.png        | Italian trattoria          | Trattoria                       |
| rest_indian.png         | Modern Indian fine dining  | The Permit Room                 |

---

## 15. What Still Needs to Be Built

### Phase 1 — Servlet Setup

- [ ] LoginServlet.java — POST, validate credentials, create session
- [ ] RegisterServlet.java — POST, insert new User into DB
- [ ] RestaurantServlet.java — GET, return JSON of restaurants (all or filtered)
- [ ] MenuServlet.java — GET with restaurantId param, return JSON of menu items

### Phase 2 — Cart and Orders

- [ ] CartServlet.java — POST (add item), GET (get cart), DELETE (remove item) using session
- [ ] OrderServlet.java — POST (place order, insert OrderTable + OrderItems), GET (get order by ID)
- [ ] Session management via HttpSession for logged-in userId

### Phase 3 — Dynamic Frontend

- [ ] restaurants.html — replace static cards with AJAX fetch from /RestaurantServlet
- [ ] menu.html — replace static groups with AJAX fetch from /MenuServlet
- [ ] cart.html — sync Add to Cart with /CartServlet (keep localStorage as fallback)
- [ ] checkout.html — POST to /OrderServlet, store returned orderId
- [ ] ordered-items.html — fetch real order data from /OrderServlet?orderId=N

### Database Tables

```sql
CREATE TABLE user (
  user_id   INT AUTO_INCREMENT PRIMARY KEY,
  username  VARCHAR(100) NOT NULL,
  password  VARCHAR(255) NOT NULL,
  email     VARCHAR(150) UNIQUE NOT NULL,
  role      VARCHAR(20) DEFAULT 'customer',
  address   TEXT,
  logout    TIMESTAMP,
  create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurant (
  restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  cuisine_type  VARCHAR(100),
  delivery_time INT,
  address       TEXT,
  rating        DECIMAL(2,1),
  is_active     BOOLEAN DEFAULT TRUE,
  image_path    VARCHAR(300)
);

CREATE TABLE menu (
  menu_id       INT AUTO_INCREMENT PRIMARY KEY,
  restaurant_id INT,
  item_name     VARCHAR(200) NOT NULL,
  description   TEXT,
  price         DECIMAL(10,2),
  is_available  BOOLEAN DEFAULT TRUE,
  image_path    VARCHAR(300),
  FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)
);

CREATE TABLE order_table (
  order_id      INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT,
  restaurant_id INT,
  order_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount  DECIMAL(10,2),
  status        VARCHAR(50) DEFAULT 'Pending',
  payment_mode  VARCHAR(20),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)
);

CREATE TABLE order_item (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id      INT,
  menu_id       INT,
  quantity      INT,
  subtotal      DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES order_table(order_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
);
```

---

## 16. Key Notes for Any Developer or AI Model

1. All prices are in INR (Rs) — NOT USD.
2. All restaurant locations are in Bengaluru, India — NOT Hyderabad.
3. Restaurant IDs 1 to 9 are fixed and hardcoded in menu.html via ?restaurant=N URL query params.
4. Filter categories on restaurants.html use: "South Indian", "North Indian", "Italian", "Asian", "Cafe" (capital first letter, with spaces).
5. Filter categories on menu.html use: "south-indian", "north-indian", "italian", "asian", "cafe" (lowercase, hyphens) in data-category attribute.
6. Design theme is dark mode with neon lime (#caff00) as accent. Do NOT change this.
7. Restaurant ID 8 (Trattoria) is marked is_active=false (closed) — it shows as closed in the UI.
8. LocalStorage handles cart currently. Backend integration runs in parallel without breaking the frontend.
9. DAO interfaces are in com.instafoo.dao; implementations in com.instafoo.daoImp.
10. styles.css is the global stylesheet — changes here affect ALL pages. Add page-specific styles in each HTML file's own style block instead.
11. The navbar across all pages has: Restaurants, Full Menu, Insta-Tracker, Cart, Sign In, Join Instafoods.
12. The ".feat-card" CSS class used on landing.html is defined in landing.html's own style block, NOT in styles.css.
13. All images use "loading=lazy" for performance.

---

Last updated: 2026-06-16
Project: Instafoods
Developer: Rajat
