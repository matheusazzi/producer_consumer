# ProducerConsumer

#### TODO
- [ ] Add a limit to beers list
- [ ] Improve beers list print

### Dependencies
To run this project you must have [Elixir](http://elixir-lang.org/install.html) and [Mix](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html) installed on your machine.

- Elixir 1.2 or above

### Running

You can run Elixir’s interactive shell including Mix.

```bash
iex -S mix
```

Then to start you need to pass a number of producers and consumers:

```elixir
Manager.start(3,4) # 3 producers / 4 consumers
```
