const time = Variable("", {
  poll: [1000, 'date "+%a %b %d %H:%M:%S"'],
});

const Clock = () =>
  Widget.Label({
    class_name: "clock",
    label: time.bind(),
  });

export default Clock;
