## Running the app
To see the code in action run the following command in the project root directory.

```
$ ruby sample.rb
```


## Running the tests
To see the tests in action run the following command in the project root directory.

```
$ rspec
```


## About the code
The app could have been written with less lines of codes and less complexity. The added complexity was a semi-conscious decision in order to make the interface simpler (trade-off). Admittedly the code has a lot more room for simplification, and this can be make even simpler by introducing a DB/ORM.


## Initializing a basket
Baskets can be created by simply Running
```ruby
basket = Basket.new
```

Or they can optionally be initialized with a Catalogue
```ruby
catalogue = Catalogue.new
basket = Basket.new(catalogue)
```

Catalogues have a list of products and offers baked in to the class (This would never be the case in production).
Similar to the basket, Catalogue can also be initialized with its own list of products and offers. See source for reference (`lib/catalogue.rb`)


## Offers

### How Offers work
*Disclaimer:* The promotion mechanism required for the given task is extremely simple. However, the implementation adds a slight layer of complexity in order to facilitate a bit more flexibility (future-proof). This means it is not a MVP of the task. The conscious decision of adding this extra flexibility was primarily because it was a fun problem to solve (:p) and the opportunity cost in terms of effort and time was small enough to go for a more complex solution.

*Going further:* with the current setup it would be easy to add a `trigger_amount` field to the promotions object. This would allow us to have promotions of the type `Spend more than $100 and get 10% discount`. It would also allow us to handle the staggered delivery charges as a kind of promotion by adding a `type` field.


The items is an array of hashes indicating the product and it's quantity.
Not all example types have been tested fully.

### Examples
**Example 1**: Buy 2 product X(code: 001) and get product Y(code: 002) free
```javascript
{
  "trigger_entries": [ {"001": 2}, {"002": 1} ],
  "affected_entries": [{"002": 1}],
  "new_unit_price": 0.00,
  "discount_percentage": nil
},
```

**Example 2**: Buy 2 product X(001) and get second half price
```javascript
{
  "trigger_entries": [ {"001": 2} ],
  "affected_entries": [{"001": 1}],
  "new_unit_price": nil,
  "discount_percentage": 50
},
```

**Example 3**: Buy 2 product X and get both for $3.99
```javascript
{
  "trigger_entries": [ {"001": 2} ],
  "affected_entries": [{"001": 2}],
  "new_unit_price": 399,
  "discount_percentage": nil
},
```

**Example 4**: Buy 2 product X and get one for $3.99
```javascript
{
  "trigger_entries": {"001": 2},
  "affected_entries": {"001": 1},
  "new_unit_price": 399,
  "discount_percentage": nil
},
```

**Example 5**: Buy product X and product Y and get 20% discount on entire basket
```javascript
{
  "trigger_entries": {"001": 1, "002": 1},
  "affected_entries": nil,
  "new_unit_price": nil,
  "discount_percentage": 20
},
```

**Example 6**: Buy product X and product Y and get 20% discount on just these items
```javascript
{
  "trigger_entries": [ {"001": 1}, {"002": 1} ],
  "affected_entries": [ {"001": 1}, {"002": 1} ]
  "new_unit_price": nil,
  "discount_percentage": 20
},
```
