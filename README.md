# ProducerConsumer

Producer's job is to generate data (a beer), put into the buffer (a fixed-size queue), and start again. At the same time, Consumers are consuming the data (removing it from the buffer), one piece at a time.

Consumers will ask for beer when they're available and Producers will be sending beers they made.

You can have multiple Producers and Consumers running, you must ensure that:

- All Consumers drink and do it in request order;
- Beers made first are consumed first;
- Don't put beers into buffer if the buffer is full.

### Dependencies
To run this project you must have [Elixir](http://elixir-lang.org/install.html) installed on your machine.

- Elixir 1.2 or above

### Running

You can run Elixir’s interactive shell including Mix to compile the code.

```bash
iex -S mix
```

Then to start you need to pass a number of producers, consumers and the buffer size:

```elixir
Manager.start(producers: 3, consumers: 4, buffer_size: 5)
```
