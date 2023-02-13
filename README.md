To execute the targets execute:

```sh
make
./bin/hello
```

---

To execute unit tests execute:

```sh
make test
```

You need to have [`Criterion`](https://github.com/Snaipe/Criterion) installed.

---

To generate your `compile_commands.json` file execute:

```sh
bear -- make all test
```

You need to have [`bear`](https://github.com/rizsotto/Bear) installed.
