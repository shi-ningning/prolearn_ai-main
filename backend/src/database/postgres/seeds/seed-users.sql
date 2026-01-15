-- Seed data for development/testing
-- DO NOT RUN IN PRODUCTION

-- Sample users (passwords should be hashed in real application)
INSERT INTO users (firebase_uid, email, name, student_id, section, course, email_verified) VALUES
    ('dev-user-1', 'john.doe@example.com', 'John Doe', '2024-001', 'CS-3A', 'Computer Science', TRUE),
    ('dev-user-2', 'jane.smith@example.com', 'Jane Smith', '2024-002', 'CS-3A', 'Computer Science', TRUE),
    ('dev-user-3', 'alice.johnson@example.com', 'Alice Johnson', '2024-003', 'IT-2B', 'Information Technology', FALSE)
ON CONFLICT (firebase_uid) DO NOTHING;

-- Sample projects
INSERT INTO projects (user_id, title, description, status, priority, progress) 
SELECT 
    u.id,
    'Final Year Thesis',
    'Research and implementation of AI-based learning system',
    'active',
    'high',
    45
FROM users u WHERE u.email = 'john.doe@example.com'
ON CONFLICT DO NOTHING;

INSERT INTO projects (user_id, title, description, status, priority, progress) 
SELECT 
    u.id,
    'Mobile App Development',
    'Flutter-based educational mobile application',
    'active',
    'medium',
    60
FROM users u WHERE u.email = 'jane.smith@example.com'
ON CONFLICT DO NOTHING;

-- Sample tasks
INSERT INTO tasks (user_id, title, description, is_completed, priority) 
SELECT 
    u.id,
    'Complete literature review',
    'Research and document relevant academic papers',
    FALSE,
    'high'
FROM users u WHERE u.email = 'john.doe@example.com';

INSERT INTO tasks (user_id, title, description, is_completed, priority) 
SELECT 
    u.id,
    'Implement user authentication',
    'Add Firebase authentication to mobile app',
    TRUE,
    'high'
FROM users u WHERE u.email = 'jane.smith@example.com';

-- Sample analytics events
INSERT INTO analytics_events (user_id, event_type, event_data)
SELECT 
    u.id,
    'login',
    '{"device": "web", "browser": "Chrome"}'::jsonb
FROM users u WHERE u.email = 'john.doe@example.com';

SELECT 'Seed data inserted successfully!' as result;
