#!/usr/bin/env node
/**
 * convert-images.js
 *
 * Script to rename image files (replace spaces with _), convert them to WebP, and update references in HTML files.
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');
const sharp = require('sharp');

(async () => {
    const mapping = {};

    // Step 1: Sanitize existing .webp files with spaces
    const webpFiles = glob.sync('assets/images/**/*.webp', { nodir: true });
    for (const file of webpFiles) {
        const dir = path.dirname(file);
        const ext = path.extname(file);
        const name = path.basename(file, ext);
        const sanitizedName = name.replace(/\s+/g, '_');
        if (name !== sanitizedName) {
            const newPath = path.join(dir, sanitizedName + ext);
            fs.renameSync(file, newPath);
            const oldRef = file.split(path.sep).join('/');
            const newRef = newPath.split(path.sep).join('/');
            mapping[oldRef] = newRef;
            console.log(`Renamed WebP: ${oldRef} -> ${newRef}`);
        }
    }

    // Step 2: Process original image files
    const imageFiles = glob.sync('assets/images/**/*.+(png|jpg|jpeg|gif)', { nodir: true });
    for (const file of imageFiles) {
        const dir = path.dirname(file);
        const ext = path.extname(file);
        const name = path.basename(file, ext);
        const sanitizedName = name.replace(/\s+/g, '_');
        let sanitizedPath = file;
        if (name !== sanitizedName) {
            sanitizedPath = path.join(dir, sanitizedName + ext);
            fs.renameSync(file, sanitizedPath);
            console.log(`Renamed image: ${file} -> ${sanitizedPath}`);
        }

        // Convert to WebP
        const webpPath = path.join(dir, sanitizedName + '.webp');
        try {
            await sharp(sanitizedPath)
                .webp({ quality: 80 })
                .toFile(webpPath);
            console.log(`Converted to WebP: ${webpPath}`);
            // Delete original file
            //fs.unlinkSync(sanitizedPath);
            //console.log(`Deleted original: ${sanitizedPath}`);
            const oldRef = sanitizedPath.split(path.sep).join('/');
            const newRef = webpPath.split(path.sep).join('/');
            mapping[oldRef] = newRef;
        } catch (err) {
            console.error(`Error processing ${sanitizedPath}:`, err);
        }
    }

    // Step 3: Update HTML references
    const htmlFiles = glob.sync('**/*.html', { ignore: 'node_modules/**' });
    for (const file of htmlFiles) {
        let content = fs.readFileSync(file, 'utf8');
        let updated = content;
        for (const [oldRef, newRef] of Object.entries(mapping)) {
            const pattern = oldRef.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            const regex = new RegExp(pattern, 'g');
            updated = updated.replace(regex, newRef);
        }
        if (updated !== content) {
            fs.writeFileSync(file, updated, 'utf8');
            console.log(`Updated HTML: ${file}`);
        }
    }
})(); 