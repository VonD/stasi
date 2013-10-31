# Stasi [![Build Status](https://secure.travis-ci.org/VonD/stasi.png)](http://travis-ci.org/VonD/stasi) [![Code Climate](https://codeclimate.com/repos/527292a713d63739ac003d17/badges/dab22ada64e26edbe8f5/gpa.png)](https://codeclimate.com/repos/527292a713d63739ac003d17/feed)

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
user.can? :read, @post
```

You define permissions in an initializer :

```ruby
Robotnik::Authorization::Law.define do

  default do
    can :read, Post
  end
  
  status :admin do
    can :edit, Post, if: Proc.new{ |post| post.editable? }
    can :destroy, Post
  end
  
  status :guest do
    can :comment, :commentable
  end
  
end
```

Undefined permissions default to `false`.
`:admin` and `:guest`, in this example, must be method names on the `user` object. The only method name that is not allowed is `:default`, as `status :default` is equivalent to `default`.

The `can` method takes two arguments : an action name as a symbol, and a resource. The resource can be :

* a class, eg. `Post`
* a symbol, eg. `:commentable`. The authorization will be applied if `@post.commentable` returns `true`. This method can take one argument, in which case, the user object will be passed to it.

When checking permission, you can pass an `:as` option to provide the right resource. As the gem in ORM agnostic, this can be useful when checking on a collection :

```ruby
# if you defined the ability as : can :read, Post
current_user.can? :read, Post.published, as: Post
```

Optionnally, the `can` method can take a hash with conditions (hash keys can be `if` and `unless`, values can be Proc, or a symbol on which will be called `to_proc`. The resource tested will be yielded).
Finally, the `can` method can take a block, in which case the `can?` method will return the return value of the block. This is useful when defining abilities on collections :

```ruby
  can :index, Post do |posts|
    posts.where(published: true)
  end
```

The `cannot` method takes only two arguments : the action name, and the resource.

## Milestones

* reload config in dev mode in rails
* yield user to blocks and procs in defining abilities
* alias actions :manage, :all, :read => [:index, :show], :create => [:new, :create], …
* load specific permissions from db
