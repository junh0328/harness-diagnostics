#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const inputPath =
  process.argv[2] ||
  path.join(__dirname, "..", "references", "score-template.json");

const raw = fs.readFileSync(inputPath, "utf8");
const data = JSON.parse(raw);
const p = data.principles || {};

const score = (key) => {
  const value = Number(p[key]);
  if (!Number.isFinite(value)) {
    throw new Error(`Invalid score for ${key}`);
  }
  return value;
};

const dimA = (score("P1") + score("P2") + score("P5") + score("P12")) / 4;
const dimB = (score("P3") + score("P4") + score("P10")) / 3;
const dimC = (score("P6") + score("P9") + score("P11")) / 3;
const dimD = (score("P7") + score("P8")) / 2;
const totalRaw = (dimA * 0.3 + dimB * 0.3 + dimC * 0.2 + dimD * 0.2) * 10;
const total = Math.round(totalRaw * 10) / 10;

const grade =
  total >= 80 ? "L5" : total >= 60 ? "L4" : total >= 40 ? "L3" : total >= 20 ? "L2" : "L1";

console.log(JSON.stringify({
  input: inputPath,
  dimensions: {
    A: Number(dimA.toFixed(2)),
    B: Number(dimB.toFixed(2)),
    C: Number(dimC.toFixed(2)),
    D: Number(dimD.toFixed(2)),
  },
  total,
  grade,
}, null, 2));
