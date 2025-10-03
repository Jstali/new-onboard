-- =============================================================================
-- ENHANCED EMPLOYEE MANAGEMENT MIGRATION
-- =============================================================================
-- Migration: 002_enhanced_employee_management.sql
-- Description: Adds enhanced employee management features including performance tracking,
--             employee reviews, and advanced reporting capabilities
-- 
-- Usage:
-- 1. Backup your existing database first
-- 2. Run this script on your existing database
-- 3. This will add new tables and features for enhanced employee management
-- =============================================================================

-- =============================================================================
-- MIGRATION LOGGING
-- =============================================================================

-- Create migration log entry
INSERT INTO migration_log (migration_name, executed_at, status, details)
VALUES ('ENHANCED_EMPLOYEE_MANAGEMENT_MIGRATION', CURRENT_TIMESTAMP, 'STARTED', 'Starting enhanced employee management migration process');

-- =============================================================================
-- PERFORMANCE TRACKING TABLES
-- =============================================================================

-- Employee performance reviews table
CREATE TABLE IF NOT EXISTS employee_performance_reviews (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    reviewer_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    review_type VARCHAR(50) DEFAULT 'annual' CHECK (review_type IN ('annual', 'quarterly', 'monthly', 'probation')),
    overall_rating DECIMAL(3,2) CHECK (overall_rating >= 1.0 AND overall_rating <= 5.0),
    goals_achieved INTEGER DEFAULT 0,
    goals_total INTEGER DEFAULT 0,
    strengths TEXT,
    areas_for_improvement TEXT,
    development_plan TEXT,
    reviewer_comments TEXT,
    employee_comments TEXT,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'under_review', 'completed', 'cancelled')),
    submitted_at TIMESTAMP,
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance goals table
CREATE TABLE IF NOT EXISTS performance_goals (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    goal_title VARCHAR(255) NOT NULL,
    goal_description TEXT,
    goal_type VARCHAR(50) DEFAULT 'personal' CHECK (goal_type IN ('personal', 'team', 'departmental', 'company')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    target_date DATE NOT NULL,
    progress_percentage INTEGER DEFAULT 0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled', 'overdue')),
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance metrics table
CREATE TABLE IF NOT EXISTS performance_metrics (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    metric_name VARCHAR(100) NOT NULL,
    metric_value DECIMAL(10,2),
    metric_unit VARCHAR(50),
    measurement_date DATE NOT NULL,
    target_value DECIMAL(10,2),
    is_achieved BOOLEAN DEFAULT false,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- EMPLOYEE DEVELOPMENT TABLES
-- =============================================================================

-- Training programs table
CREATE TABLE IF NOT EXISTS training_programs (
    id SERIAL PRIMARY KEY,
    program_name VARCHAR(255) NOT NULL,
    description TEXT,
    program_type VARCHAR(50) DEFAULT 'internal' CHECK (program_type IN ('internal', 'external', 'online', 'workshop')),
    duration_hours INTEGER,
    cost DECIMAL(10,2),
    provider VARCHAR(255),
    is_mandatory BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee training records table
CREATE TABLE IF NOT EXISTS employee_training_records (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    training_program_id INTEGER REFERENCES training_programs(id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    completion_date DATE,
    status VARCHAR(50) DEFAULT 'enrolled' CHECK (status IN ('enrolled', 'in_progress', 'completed', 'cancelled', 'failed')),
    score DECIMAL(5,2),
    certificate_url VARCHAR(500),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Skills table
CREATE TABLE IF NOT EXISTS skills (
    id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    skill_category VARCHAR(50),
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee skills table
CREATE TABLE IF NOT EXISTS employee_skills (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    skill_id INTEGER REFERENCES skills(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) DEFAULT 'beginner' CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
    years_of_experience DECIMAL(3,1),
    last_updated DATE,
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, skill_id)
);

-- =============================================================================
-- ADVANCED REPORTING TABLES
-- =============================================================================

-- Employee reports table
CREATE TABLE IF NOT EXISTS employee_reports (
    id SERIAL PRIMARY KEY,
    report_name VARCHAR(255) NOT NULL,
    report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('attendance', 'performance', 'leave', 'expense', 'training', 'custom')),
    report_data JSONB,
    filters JSONB,
    generated_by INTEGER REFERENCES users(id),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_scheduled BOOLEAN DEFAULT false,
    schedule_frequency VARCHAR(20) CHECK (schedule_frequency IN ('daily', 'weekly', 'monthly', 'quarterly', 'yearly')),
    next_run_date TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dashboard widgets table
CREATE TABLE IF NOT EXISTS dashboard_widgets (
    id SERIAL PRIMARY KEY,
    widget_name VARCHAR(100) NOT NULL,
    widget_type VARCHAR(50) NOT NULL,
    widget_config JSONB,
    position_x INTEGER DEFAULT 0,
    position_y INTEGER DEFAULT 0,
    width INTEGER DEFAULT 4,
    height INTEGER DEFAULT 3,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User dashboard preferences table
CREATE TABLE IF NOT EXISTS user_dashboard_preferences (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    widget_id INTEGER REFERENCES dashboard_widgets(id) ON DELETE CASCADE,
    is_visible BOOLEAN DEFAULT true,
    position_x INTEGER DEFAULT 0,
    position_y INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, widget_id)
);

-- =============================================================================
-- NOTIFICATION SYSTEM TABLES
-- =============================================================================

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) DEFAULT 'info' CHECK (notification_type IN ('info', 'warning', 'error', 'success', 'reminder')),
    is_read BOOLEAN DEFAULT false,
    action_url VARCHAR(500),
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notification templates table
CREATE TABLE IF NOT EXISTS notification_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) UNIQUE NOT NULL,
    template_type VARCHAR(50) NOT NULL,
    subject_template TEXT,
    message_template TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- AUDIT AND COMPLIANCE TABLES
-- =============================================================================

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Compliance requirements table
CREATE TABLE IF NOT EXISTS compliance_requirements (
    id SERIAL PRIMARY KEY,
    requirement_name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    is_mandatory BOOLEAN DEFAULT true,
    frequency VARCHAR(50) DEFAULT 'annual' CHECK (frequency IN ('daily', 'weekly', 'monthly', 'quarterly', 'annual', 'as_needed')),
    due_date DATE,
    responsible_role VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee compliance records table
CREATE TABLE IF NOT EXISTS employee_compliance_records (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    requirement_id INTEGER REFERENCES compliance_requirements(id) ON DELETE CASCADE,
    completion_date DATE,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'overdue', 'exempt')),
    evidence_url VARCHAR(500),
    verified_by INTEGER REFERENCES users(id),
    verified_at TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Performance review indexes
CREATE INDEX IF NOT EXISTS idx_performance_reviews_employee_id ON employee_performance_reviews(employee_id);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_reviewer_id ON employee_performance_reviews(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_period ON employee_performance_reviews(review_period_start, review_period_end);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_status ON employee_performance_reviews(status);

-- Performance goals indexes
CREATE INDEX IF NOT EXISTS idx_performance_goals_employee_id ON performance_goals(employee_id);
CREATE INDEX IF NOT EXISTS idx_performance_goals_status ON performance_goals(status);
CREATE INDEX IF NOT EXISTS idx_performance_goals_target_date ON performance_goals(target_date);

-- Training indexes
CREATE INDEX IF NOT EXISTS idx_training_records_employee_id ON employee_training_records(employee_id);
CREATE INDEX IF NOT EXISTS idx_training_records_program_id ON employee_training_records(training_program_id);
CREATE INDEX IF NOT EXISTS idx_training_records_status ON employee_training_records(status);

-- Skills indexes
CREATE INDEX IF NOT EXISTS idx_employee_skills_employee_id ON employee_skills(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_skills_skill_id ON employee_skills(skill_id);
CREATE INDEX IF NOT EXISTS idx_employee_skills_proficiency ON employee_skills(proficiency_level);

-- Notification indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);

-- Audit log indexes
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_name ON audit_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);

-- =============================================================================
-- SAMPLE DATA INSERTION
-- =============================================================================

-- Insert sample skills (only if MIGRATION_SKIP_SAMPLE_DATA is false)
DO $$
BEGIN
    IF '${MIGRATION_SKIP_SAMPLE_DATA}' = 'false' THEN
        INSERT INTO skills (skill_name, skill_category, description, is_active) VALUES
        ('JavaScript', 'Programming', 'JavaScript programming language', true),
        ('React', 'Frontend', 'React.js library for building user interfaces', true),
        ('Node.js', 'Backend', 'Node.js runtime for server-side JavaScript', true),
        ('PostgreSQL', 'Database', 'PostgreSQL database management system', true),
        ('Project Management', 'Soft Skills', 'Project management methodologies and tools', true),
        ('Communication', 'Soft Skills', 'Effective communication skills', true),
        ('Leadership', 'Soft Skills', 'Team leadership and management skills', true),
        ('Data Analysis', 'Analytics', 'Data analysis and visualization', true)
        ON CONFLICT (skill_name) DO NOTHING;
        
        RAISE NOTICE 'Sample skills data inserted';
    ELSE
        RAISE NOTICE 'Sample skills data skipped (MIGRATION_SKIP_SAMPLE_DATA=true)';
    END IF;
END $$;

-- Insert sample training programs (only if MIGRATION_SKIP_SAMPLE_DATA is false)
DO $$
BEGIN
    IF '${MIGRATION_SKIP_SAMPLE_DATA}' = 'false' THEN
        INSERT INTO training_programs (program_name, description, program_type, duration_hours, cost, provider, is_mandatory, is_active) VALUES
        ('New Employee Orientation', 'Comprehensive orientation program for new employees', 'internal', 8, 0.00, '${DEFAULT_TRAINING_PROVIDER}', true, true),
        ('Leadership Development', 'Advanced leadership skills training', 'external', 40, ${LEADERSHIP_TRAINING_COST}, '${LEADERSHIP_TRAINING_PROVIDER}', false, true),
        ('Cybersecurity Awareness', 'Cybersecurity best practices and awareness', 'online', 4, 0.00, '${SECURITY_TRAINING_PROVIDER}', true, true),
        ('Agile Methodology', 'Agile project management training', 'workshop', 16, ${AGILE_TRAINING_COST}, '${AGILE_TRAINING_PROVIDER}', false, true),
        ('Communication Skills', 'Effective communication and presentation skills', 'internal', 12, 0.00, '${DEFAULT_TRAINING_PROVIDER}', false, true)
        ON CONFLICT DO NOTHING;
        
        RAISE NOTICE 'Sample training programs data inserted';
    ELSE
        RAISE NOTICE 'Sample training programs data skipped (MIGRATION_SKIP_SAMPLE_DATA=true)';
    END IF;
END $$;

-- Insert sample notification templates (only if MIGRATION_SKIP_SAMPLE_DATA is false)
DO $$
BEGIN
    IF '${MIGRATION_SKIP_SAMPLE_DATA}' = 'false' THEN
        INSERT INTO notification_templates (template_name, template_type, subject_template, message_template, is_active) VALUES
        ('leave_approval', 'leave', 'Leave Request Approved', 'Your leave request for {{start_date}} to {{end_date}} has been approved by {{approver_name}}.', true),
        ('leave_rejection', 'leave', 'Leave Request Rejected', 'Your leave request for {{start_date}} to {{end_date}} has been rejected. Reason: {{rejection_reason}}', true),
        ('expense_approval', 'expense', 'Expense Request Approved', 'Your expense request of {{amount}} for {{category}} has been approved by {{approver_name}}.', true),
        ('performance_review_due', 'performance', 'Performance Review Due', 'Your {{review_type}} performance review is due on {{due_date}}. Please complete it as soon as possible.', true),
        ('training_reminder', 'training', 'Training Reminder', 'You have a training session scheduled for {{program_name}} on {{date}} at {{time}}.', true)
        ON CONFLICT (template_name) DO NOTHING;
        
        RAISE NOTICE 'Sample notification templates data inserted';
    ELSE
        RAISE NOTICE 'Sample notification templates data skipped (MIGRATION_SKIP_SAMPLE_DATA=true)';
    END IF;
END $$;

-- Insert sample compliance requirements (only if MIGRATION_SKIP_SAMPLE_DATA is false)
DO $$
BEGIN
    IF '${MIGRATION_SKIP_SAMPLE_DATA}' = 'false' THEN
        INSERT INTO compliance_requirements (requirement_name, description, category, is_mandatory, frequency, responsible_role, is_active) VALUES
        ('Code of Conduct Acknowledgment', 'Annual acknowledgment of company code of conduct', 'Ethics', true, '${COMPLIANCE_DEFAULT_FREQUENCY}', '${COMPLIANCE_DEFAULT_ROLE}', true),
        ('Data Privacy Training', 'Data privacy and protection training', 'Security', true, '${COMPLIANCE_DEFAULT_FREQUENCY}', '${COMPLIANCE_DEFAULT_ROLE}', true),
        ('Safety Training', 'Workplace safety training and certification', 'Safety', true, '${COMPLIANCE_DEFAULT_FREQUENCY}', '${COMPLIANCE_DEFAULT_ROLE}', true),
        ('Anti-Harassment Training', 'Anti-harassment and diversity training', 'HR', true, '${COMPLIANCE_DEFAULT_FREQUENCY}', '${COMPLIANCE_DEFAULT_ROLE}', true),
        ('Confidentiality Agreement', 'Confidentiality and non-disclosure agreement', 'Legal', true, 'as_needed', '${COMPLIANCE_DEFAULT_ROLE}', true)
        ON CONFLICT DO NOTHING;
        
        RAISE NOTICE 'Sample compliance requirements data inserted';
    ELSE
        RAISE NOTICE 'Sample compliance requirements data skipped (MIGRATION_SKIP_SAMPLE_DATA=true)';
    END IF;
END $$;

-- Insert sample dashboard widgets (only if MIGRATION_SKIP_SAMPLE_DATA is false)
DO $$
BEGIN
    IF '${MIGRATION_SKIP_SAMPLE_DATA}' = 'false' THEN
        INSERT INTO dashboard_widgets (widget_name, widget_type, widget_config, position_x, position_y, width, height, is_active) VALUES
        ('attendance_summary', 'chart', '{"chart_type": "bar", "data_source": "attendance", "period": "monthly"}', 0, 0, 4, 3, true),
        ('leave_balance', 'metric', '{"metric_type": "leave_balance", "show_trend": true}', 4, 0, 2, 2, true),
        ('recent_activities', 'list', '{"data_source": "recent_activities", "limit": 10}', 6, 0, 6, 4, true),
        ('performance_summary', 'chart', '{"chart_type": "donut", "data_source": "performance", "period": "quarterly"}', 0, 3, 4, 3, true),
        ('upcoming_training', 'list', '{"data_source": "upcoming_training", "limit": 5}', 4, 2, 4, 4, true),
        ('expense_summary', 'metric', '{"metric_type": "expense_summary", "period": "monthly"}', 8, 0, 4, 2, true)
        ON CONFLICT DO NOTHING;
        
        RAISE NOTICE 'Sample dashboard widgets data inserted';
    ELSE
        RAISE NOTICE 'Sample dashboard widgets data skipped (MIGRATION_SKIP_SAMPLE_DATA=true)';
    END IF;
END $$;

-- =============================================================================
-- DATA VALIDATION
-- =============================================================================

-- Validate data integrity
DO $$
DECLARE
    table_count INTEGER;
    skills_count INTEGER;
    training_count INTEGER;
    templates_count INTEGER;
    compliance_count INTEGER;
    widgets_count INTEGER;
BEGIN
    -- Count new tables
    SELECT COUNT(*) INTO table_count FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name IN (
        'employee_performance_reviews', 'performance_goals', 'performance_metrics',
        'training_programs', 'employee_training_records', 'skills', 'employee_skills',
        'employee_reports', 'dashboard_widgets', 'user_dashboard_preferences',
        'notifications', 'notification_templates', 'audit_logs',
        'compliance_requirements', 'employee_compliance_records'
    );
    
    -- Count sample data
    SELECT COUNT(*) INTO skills_count FROM skills;
    SELECT COUNT(*) INTO training_count FROM training_programs;
    SELECT COUNT(*) INTO templates_count FROM notification_templates;
    SELECT COUNT(*) INTO compliance_count FROM compliance_requirements;
    SELECT COUNT(*) INTO widgets_count FROM dashboard_widgets;
    
    -- Log validation results
    RAISE NOTICE '========================================';
    RAISE NOTICE 'ENHANCED EMPLOYEE MANAGEMENT MIGRATION VALIDATION';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'New Tables Created: %', table_count;
    RAISE NOTICE 'Skills Added: %', skills_count;
    RAISE NOTICE 'Training Programs Added: %', training_count;
    RAISE NOTICE 'Notification Templates Added: %', templates_count;
    RAISE NOTICE 'Compliance Requirements Added: %', compliance_count;
    RAISE NOTICE 'Dashboard Widgets Added: %', widgets_count;
    RAISE NOTICE '========================================';
    
    -- Verify all expected tables exist
    IF table_count < 15 THEN
        RAISE WARNING 'Expected at least 15 new tables, found only %', table_count;
    ELSE
        RAISE NOTICE 'All expected tables have been created successfully';
    END IF;
    
    RAISE NOTICE 'Enhanced employee management migration validation completed successfully';
END $$;

-- =============================================================================
-- MIGRATION COMPLETION
-- =============================================================================

-- Update migration log
UPDATE migration_log 
SET status = 'COMPLETED', 
    details = 'Enhanced employee management migration completed successfully. Added performance tracking, training management, notifications, and compliance features.'
WHERE migration_name = 'ENHANCED_EMPLOYEE_MANAGEMENT_MIGRATION';

-- Final success message
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'ENHANCED EMPLOYEE MANAGEMENT MIGRATION COMPLETED!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'New features added:';
    RAISE NOTICE '• Performance tracking and reviews';
    RAISE NOTICE '• Training and skills management';
    RAISE NOTICE '• Advanced reporting and dashboards';
    RAISE NOTICE '• Notification system';
    RAISE NOTICE '• Audit logging and compliance';
    RAISE NOTICE 'Your database now has enhanced employee management capabilities!';
    RAISE NOTICE '========================================';
END $$;
