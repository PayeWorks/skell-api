# API
## Setup

  - Get the code

```
git clone git@github.com:payeworks/paye_project_api.git paye_project_api
```

  - Install dependencies

```
cd paye_project_api
gem install dep
dep install
```

  - Install test's dependencies

```
cd paye_project_api
dep install -f .gems-test
```

## Launch

```
rackup
```

## Testing

```
rake test:all      # Run tests for all
rake test:libs     # Run tests for libs
rake test:models   # Run tests for models
rake test:routes   # Run tests for routes
```

## Benchmarking

```
rake bench         # Run benchs tests for all
rake bench:all     # Run tests for all
rake bench:routes  # Run tests for routes
```