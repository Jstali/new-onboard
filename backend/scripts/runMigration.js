const { Pool } = require("pg");
const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: "./config.env" });

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Function to replace environment variables in SQL
const replaceEnvironmentVariables = (sql) => {
  const envVars = {
    'COMPANY_NAME': process.env.COMPANY_NAME || 'NXZEN',
    'COMPANY_EMAIL_DOMAIN': process.env.COMPANY_EMAIL_DOMAIN || 'nxzen.com',
    'HR_DEPARTMENT_EMAIL': process.env.HR_DEPARTMENT_EMAIL || 'hr@nxzen.com',
    'DEFAULT_ANNUAL_LEAVES': process.env.DEFAULT_ANNUAL_LEAVES || '27',
    'DEFAULT_TRAINING_PROVIDER': process.env.DEFAULT_TRAINING_PROVIDER || 'HR Department',
    'LEADERSHIP_TRAINING_COST': process.env.LEADERSHIP_TRAINING_COST || '2500.00',
    'AGILE_TRAINING_COST': process.env.AGILE_TRAINING_COST || '800.00',
    'SECURITY_TRAINING_PROVIDER': process.env.SECURITY_TRAINING_PROVIDER || 'Security Training Co.',
    'LEADERSHIP_TRAINING_PROVIDER': process.env.LEADERSHIP_TRAINING_PROVIDER || 'Leadership Institute',
    'AGILE_TRAINING_PROVIDER': process.env.AGILE_TRAINING_PROVIDER || 'Agile Consultants',
    'NOTIFICATION_FROM_EMAIL': process.env.NOTIFICATION_FROM_EMAIL || 'noreply@nxzen.com',
    'NOTIFICATION_FROM_NAME': process.env.NOTIFICATION_FROM_NAME || 'NXZEN HR System',
    'COMPLIANCE_DEFAULT_FREQUENCY': process.env.COMPLIANCE_DEFAULT_FREQUENCY || 'annual',
    'COMPLIANCE_DEFAULT_ROLE': process.env.COMPLIANCE_DEFAULT_ROLE || 'employee',
    'MIGRATION_SKIP_SAMPLE_DATA': process.env.MIGRATION_SKIP_SAMPLE_DATA || 'false'
  };

  let processedSQL = sql;
  Object.entries(envVars).forEach(([key, value]) => {
    const regex = new RegExp(`\\$\\{${key}\\}`, 'g');
    processedSQL = processedSQL.replace(regex, value);
  });

  return processedSQL;
};

const runMigration = async (migrationFile) => {
  try {
    console.log("🚀 Starting Migration Process...");
    console.log("=================================");
    console.log(`📁 Migration File: ${migrationFile}`);
    console.log(`🏢 Company: ${process.env.COMPANY_NAME || 'NXZEN'}`);
    console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log("=================================");

    // Check if migration file exists
    const migrationPath = path.join(__dirname, "..", "migrations", migrationFile);
    if (!fs.existsSync(migrationPath)) {
      throw new Error(`Migration file not found: ${migrationPath}`);
    }

    // Read migration file
    let migrationSQL = fs.readFileSync(migrationPath, "utf8");
    
    // Replace environment variables in the SQL file
    migrationSQL = replaceEnvironmentVariables(migrationSQL);
    
    console.log("✅ Migration file loaded and processed successfully");

    // Check database connection
    console.log("🔌 Testing database connection...");
    await pool.query("SELECT 1");
    console.log("✅ Database connection successful");

    // Check if migration has already been run
    const migrationName = migrationFile.replace(".sql", "").toUpperCase();
    const existingMigration = await pool.query(
      "SELECT * FROM migration_log WHERE migration_name = $1",
      [migrationName]
    );

    if (existingMigration.rows.length > 0) {
      const migration = existingMigration.rows[0];
      console.log(`⚠️  Migration already executed on ${migration.executed_at}`);
      console.log(`   Status: ${migration.status}`);
      console.log(`   Details: ${migration.details}`);
      
      const readline = require('readline');
      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
      });

      const answer = await new Promise((resolve) => {
        rl.question('Do you want to run it again? (y/N): ', resolve);
      });
      rl.close();

      if (answer.toLowerCase() !== 'y' && answer.toLowerCase() !== 'yes') {
        console.log("❌ Migration cancelled by user");
        return;
      }
    }

    // Create backup warning
    if (process.env.MIGRATION_BACKUP_BEFORE_RUN === 'true') {
      console.log("⚠️  IMPORTANT: Please backup your database before proceeding!");
      console.log("   This migration will modify your database structure.");
      console.log("   Press Ctrl+C to cancel, or wait 5 seconds to continue...");
      
      await new Promise(resolve => setTimeout(resolve, 5000));
    } else {
      console.log("ℹ️  Backup warning skipped (MIGRATION_BACKUP_BEFORE_RUN=false)");
    }

    // Execute migration
    console.log("🔄 Executing migration...");
    const startTime = Date.now();
    
    await pool.query(migrationSQL);
    
    const endTime = Date.now();
    const duration = ((endTime - startTime) / 1000).toFixed(2);
    
    console.log(`✅ Migration completed successfully in ${duration} seconds`);

    // Verify migration results
    console.log("🔍 Verifying migration results...");
    const migrationLog = await pool.query(
      "SELECT * FROM migration_log WHERE migration_name = $1 ORDER BY executed_at DESC LIMIT 1",
      [migrationName]
    );

    if (migrationLog.rows.length > 0) {
      const log = migrationLog.rows[0];
      console.log("📊 Migration Log:");
      console.log(`   Status: ${log.status}`);
      console.log(`   Executed: ${log.executed_at}`);
      console.log(`   Details: ${log.details}`);
    }

    // Count tables
    const tableCount = await pool.query(`
      SELECT COUNT(*) as count 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
    console.log(`📋 Total tables in database: ${tableCount.rows[0].count}`);

    console.log("\n🎉 Migration process completed successfully!");
    console.log("=====================================");
    console.log("Your database has been updated with the new features.");
    console.log("You can now use the enhanced employee management capabilities.");

  } catch (error) {
    console.error("❌ Migration failed:", error.message);
    console.error("Stack trace:", error.stack);
    
    // Log error to migration_log
    try {
      const migrationName = migrationFile.replace(".sql", "").toUpperCase();
      await pool.query(
        "INSERT INTO migration_log (migration_name, executed_at, status, details, error_message) VALUES ($1, $2, $3, $4, $5)",
        [migrationName, new Date(), 'FAILED', 'Migration execution failed', error.message]
      );
    } catch (logError) {
      console.error("Failed to log error:", logError.message);
    }
    
    throw error;
  } finally {
    await pool.end();
  }
};

// Get migration file from command line arguments
const migrationFile = process.argv[2];

if (!migrationFile) {
  console.log("❌ Please provide a migration file name");
  console.log("Usage: node runMigration.js <migration-file.sql>");
  console.log("\nAvailable migrations:");
  
  const migrationsDir = path.join(__dirname, "..", "migrations");
  if (fs.existsSync(migrationsDir)) {
    const files = fs.readdirSync(migrationsDir).filter(file => file.endsWith('.sql'));
    files.forEach(file => console.log(`  - ${file}`));
  }
  
  process.exit(1);
}

runMigration(migrationFile).catch(console.error);
