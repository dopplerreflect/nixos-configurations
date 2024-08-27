#!/usr/bin/env bun

import { readdir } from "node:fs/promises";
import { $ } from "bun";

const DIR = "/home/doppler/Pictures/Desktop-Backgrounds";

const files = await readdir(DIR);
const paths = files.map(file => `${DIR}/${file}`);

const getRandomPath = () => {
  let path = paths[Math.floor(Math.random() * paths.length) + 1];
  return path || getRandomPath();
};

const getMonitors = async () => {
  let shellResult = await $`hyprctl monitors -j`.quiet();
  return shellResult.json();
};
const swapImages = async () => {
  try {
    let monitors = await getMonitors();
    monitors.forEach(async monitor => {
      let path = getRandomPath();
      console.info(monitor.name, path);
      await $`swww img -o ${monitor.name} ${path}`;
    });
  } catch (e) {}
};

setInterval(swapImages, 1000 * 60 * 5);
swapImages();
