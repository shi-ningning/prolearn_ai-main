import { Router } from 'express';
import * as userController from '../controllers/user.controller';
import { authenticate } from '../middleware/auth';

const router = Router();

/**
 * @route   POST /api/users
 * @desc    Create or update user (after Firebase Auth registration)
 * @access  Private
 */
router.post('/', authenticate, userController.createOrUpdateUser);

/**
 * @route   GET /api/users/:id
 * @desc    Get user profile
 * @access  Private
 */
router.get('/:id', authenticate, userController.getUserProfile);

/**
 * @route   PUT /api/users/:id
 * @desc    Update user profile
 * @access  Private
 */
router.put('/:id', authenticate, userController.updateUserProfile);

/**
 * @route   GET /api/users/:id/stats
 * @desc    Get user statistics
 * @access  Private
 */
router.get('/:id/stats', authenticate, userController.getUserStats);

/**
 * @route   DELETE /api/users/:id
 * @desc    Delete user account
 * @access  Private
 */
router.delete('/:id', authenticate, userController.deleteUser);

export default router;
