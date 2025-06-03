#!/usr/bin/env node
/**
 * minify-assets.js
 *
 * Script to scan HTML files for CSS and JS references and minify them.
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');
const CleanCSS = require('clean-css');
const Terser = require('terser');

(async () => {
  // Find HTML files
  const htmlFiles = glob.sync('**/*.html', { ignore: 'node_modules/**' });

  const cssFiles = new Set();
  const jsFiles = new Set();

  // Extract references
  htmlFiles.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    const linkRegex = /<link[^>]+href="([^"]+\.css)"[^>]*>/g;
    const scriptRegex = /<script[^>]+src="([^"]+\.js)"[^>]*>/g;
    let match;
    while ((match = linkRegex.exec(content))) {
      const href = match[1];
      if (/^(https?:)?\/\//.test(href)) continue; // skip external
      cssFiles.add(href);
    }
    while ((match = scriptRegex.exec(content))) {
      const src = match[1];
      if (/^(https?:)?\/\//.test(src)) continue;
      jsFiles.add(src);
    }
  });

  // Minify CSS
  const cssMinifier = new CleanCSS({});
  cssFiles.forEach(relPath => {
    if (relPath.includes('.min.')) {
      console.log(`Skipping already minified CSS: ${relPath}`);
      return;
    }
    const filePath = path.normalize(relPath);
    if (!fs.existsSync(filePath)) {
      console.warn(`CSS file not found: ${relPath}`);
      return;
    }
    const input = fs.readFileSync(filePath, 'utf8');
    const output = cssMinifier.minify(input);
    if (output.errors.length) {
      console.error(`Errors minifying ${relPath}:`, output.errors);
      return;
    }
    fs.writeFileSync(filePath, output.styles, 'utf8');
    console.log(`Minified CSS: ${relPath}`);
  });

  // Minify JS
  for (const relPath of jsFiles) {
    if (relPath.includes('.min.')) {
      console.log(`Skipping already minified JS: ${relPath}`);
      continue;
    }
    const filePath = path.normalize(relPath);
    if (!fs.existsSync(filePath)) {
      console.warn(`JS file not found: ${relPath}`);
      continue;
    }
    const input = fs.readFileSync(filePath, 'utf8');
    try {
      const result = await Terser.minify(input);
      if (result.error) {
        console.error(`Error minifying ${relPath}:`, result.error);
        continue;
      }
      fs.writeFileSync(filePath, result.code, 'utf8');
      console.log(`Minified JS: ${relPath}`);
    } catch (err) {
      console.error(`Error minifying ${relPath}:`, err);
    }
  }
})();