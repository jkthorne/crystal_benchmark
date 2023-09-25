# crystal_benchmark

TODO: Write a description here

## Setup

``` shell
sudo sh -c 'echo -1 >/proc/sys/kernel/perf_event_paranoid'
sudo sysctl -w kernel.perf_event_paranoid=-1
sudo sh -c " echo 0 > /proc/sys/kernel/kptr_restrict"
sudo sysctl -w kernel.kptr_restrict=0

sudo sysctl kernel.perf_event_paranoid=-1
```


## Installation
Perf is required

``` shell
sudo apt install linux-tools-common linux-tools-generic linux-cloud-tools-generic
git clone git@github.com:crystal-lang/crystal.git
```

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/crystal_benchmark/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jack Thorne](https://github.com/your-github-user) - creator and maintainer
