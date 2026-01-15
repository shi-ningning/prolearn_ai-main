import { Router } from 'express';
import * as adminController from '../controllers/admin.controller';
import { authenticate, requireAdmin } from '../middleware/auth';

const router = Router();

// All admin routes require authentication and admin role
router.use(authenticate);
router.use(requireAdmin);

/**
 * @route   GET /api/admin/users
 * @desc    List all users
 * @access  Admin
 */
router.get('/users', adminController.listUsers);

/**
 * @route   GET /api/admin/stats
 * @desc    Get system statistics
 * @access  Admin
 */
router.get('/stats', adminController.getSystemStats);

/**
 * @route   POST /api/admin/announcements
 * @desc    Create announcement
 * @access  Admin
 */
router.post('/announcements', adminController.createAnnouncement);

/**
 * @route   DELETE /api/admin/users/:id
 * @desc    Delete user (admin)
 * @access  Admin
 */
router.delete('/users/:id', adminController.deleteUser);

export default router;
