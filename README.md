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

  default do
    can :read, :posts
  end
  
  status :admin do
    can :edit, :posts
    can :destroy, :posts
  end
  
  status :guest do
    …
  end
  
end
```

Undefined permissions default to `false`.
`:admin` and `:guest`, in this example, must be method names on the `user` object. The only method name that is not allowed is `:default`, as `status :default` is equivalent to `default`.

## Milestones

* pass directly object, and not a symbol
* pass symbol or proc to `:if` and `:unless` conditions
* alias actions :manage, :all, :read => [:index, :show], :create => [:new, :create], …
* load specific permissions from db
