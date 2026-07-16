import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import projectRoutes from './project.routes';
import taskRoutes from './task.routes';
import analyticsRoutes from './analytics.routes';
import adminRoutes from './admin.routes';
import chatRoutes from './chat.routes';

const router = Router();

// API version
const API_VERSION = process.env.API_VERSION || 'v1';

// Welcome endpoint
router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Welcome to ProLearnAI API',
    version: API_VERSION,
    timestamp: new Date().toISOString(),
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      projects: '/api/projects',
      tasks: '/api/tasks',
      analytics: '/api/analytics',
      admin: '/api/admin',
      chat: '/api/chat'
    }
  });
});

// Route modules
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/projects', projectRoutes);
router.use('/tasks', taskRoutes);
router.use('/analytics', analyticsRoutes);
router.use('/admin', adminRoutes);
router.use('/chat', chatRoutes);

export default router;
