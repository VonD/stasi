# Stasi

A small authorization library inspired by CanCan

## Usage

```ruby
gem 'stasi'
```

In the model you wish to check permissions on, e.g. User :

```ruby
include Robotnik::Authorization::Watch
```

Then you can check permissions this way :

```ruby
user.can? :read, :posts
```

You define permissions in an initializer :

```ruby
Robotnik::Authorization::Law.define do
  
  status :admin do
    can read, :posts
    can :destroy, :posts
  end
  
  status :guest do
    can :read, :post
  end
  
end
```

Undefined permissions default to `false`.
`:admin` and `:guest`, in this example, must be methods on the `user` object.

## Milestones

* pass directly object, and not a symbol
* load specific permissions from db
