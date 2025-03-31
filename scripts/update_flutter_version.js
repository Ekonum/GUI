console.log('Script update_flutter_version.js is running...');
const fs = require('fs');
const yaml = require('js-yaml');
const path = require('path');

const pubspecPath = path.join(__dirname, '..', 'pubspec.yaml'); // Path relative to script location
const newVersion = process.argv[2]; // Get version from command line argument

if (!newVersion) {
  console.error('Error: No version specified.');
  process.exit(1);
}

console.log(`Updating pubspec.yaml to version ${newVersion}...`);

try {
  // Read pubspec.yaml
  const pubspecContent = fs.readFileSync(pubspecPath, 'utf8');

  // Find the version line using a regex to preserve the structure (e.g., version: x.y.z+b)
  // This regex captures the part before '+' and the '+' sign itself if present.
  const versionRegex = /^(version:\s*)(\d+\.\d+\.\d+)(\+?\d*.*)$/m;
  const match = pubspecContent.match(versionRegex);

  if (!match) {
    throw new Error('Could not find a valid "version: x.y.z[+b]" line in pubspec.yaml');
  }

  // Construct the new version line, resetting build number to +1
  const newVersionLine = `${match[1]}${newVersion}+1`; // Reset build number to 1

  // Replace the old version line with the new one
  const updatedContent = pubspecContent.replace(versionRegex, newVersionLine);

  // Write the updated content back to pubspec.yaml
  fs.writeFileSync(pubspecPath, updatedContent, 'utf8');

  console.log(`Successfully updated pubspec.yaml version to ${newVersion}+1`);

} catch (error) {
  console.error(`Error updating pubspec.yaml: ${error.message}`);
  process.exit(1);
}