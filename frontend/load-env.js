#!/usr/bin/env node

// Load environment variables from main.env
const fs = require('fs');
const path = require('path');

const envFile = path.join(__dirname, 'main.env');

if (fs.existsSync(envFile)) {
  const envContent = fs.readFileSync(envFile, 'utf8');
  
  envContent.split('\n').forEach(line => {
    const trimmedLine = line.trim();
    
    // Skip empty lines and comments
    if (!trimmedLine || trimmedLine.startsWith('#')) {
      return;
    }
    
    // Parse KEY=VALUE format
    const equalIndex = trimmedLine.indexOf('=');
    if (equalIndex > 0) {
      const key = trimmedLine.substring(0, equalIndex).trim();
      const value = trimmedLine.substring(equalIndex + 1).trim();
      
      // Set environment variable if not already set
      if (!process.env[key]) {
        process.env[key] = value;
      }
    }
  });
  
  console.log('✅ Environment variables loaded from main.env');
} else {
  console.log('⚠️  main.env file not found, using default environment');
}

// Execute the command passed as arguments
const { spawn } = require('child_process');
const command = process.argv[2];
const args = process.argv.slice(3);

const child = spawn(command, args, { 
  stdio: 'inherit',
  shell: true 
});

child.on('close', (code) => {
  process.exit(code);
});
