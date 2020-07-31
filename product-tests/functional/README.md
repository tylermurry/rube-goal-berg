# Functional Tests

## Framework
Cypress

## Tiers

### Tier 1
Tests that represent the functional core of the product.

* Guiding Principle: If one of these tests fail, users will suffer a major outage.
* Examples: Login, booking an order, etc
* File format: `*.tier1.spec.js`

### Tier 2
Tests that are essential to application, but not a part of a critical path.

* Guiding Principle: If one of these tests fail, users may feel annoyed but could still use the product.
* Examples: Update user preferences
* File format: `*.tier2.spec.js`

# Non-Functional Tests
