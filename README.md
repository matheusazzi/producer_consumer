# ProducerConsumer

Producer's job is to generate data (a beer), put into the buffer (a fixed-size queue), and start again. At the same time, the Consumer is consuming the data (removing it from the buffer), one piece at a time.

Consumers will ask for beer when they are available and Producers will be sending beers they made.

You can have multiple Producers and Consumers running, you must ensure that all Consumers drink in request order and don't put beer into buffer if the buffer is full.

### Dependencies
To run this project you must have [Elixir](http://elixir-lang.org/install.html) installed on your machine.

- Elixir 1.2 or above

### Running

You can run Elixir’s interactive shell including Mix.

```bash
iex -S mix
```

Then to start you need to pass a number of producers and consumers:

```elixir
Manager.start(producers: 3, consumers: 4, buffer_size: 5)
```
