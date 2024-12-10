#!/usr/bin/env bun

import { parseArgs } from "node:util";
import { readdir } from "node:fs/promises";
import { $ } from "bun";

const { values } = parseArgs({
  args: Bun.argv,
  options: {
    frequency: {
      type: "string",
      short: "f",
    },
  },
  strict: true,
  allowPositionals: true,
});

type Monitor = {
  name: string;
};

const DIR = "/home/doppler/Pictures/Desktop-Backgrounds";

const files = await readdir(DIR);
const paths = files.map(file => `${DIR}/${file}`);

const getRandomPath = (): string => {
  let path = paths[Math.floor(Math.random() * paths.length) + 1];
  return path || getRandomPath();
};

const getMonitors = async (): Promise<Monitor[]> => {
  let shellResult = await $`hyprctl monitors -j`.quiet();
  return shellResult.json();
};

const swapImages = async (): Promise<void> => {
  try {
    let monitors = await getMonitors();
    monitors.forEach(async monitor => {
      let path = getRandomPath();
      await $`swww img -o ${monitor.name} ${path}`;
    });
  } catch (e) {}
};

if (values.frequency)
  setInterval(swapImages, Number(values.frequency) || 1000 * 60 * 5);

swapImages();
