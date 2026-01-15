import { Router } from 'express';
import * as analyticsController from '../controllers/analytics.controller';
import { authenticate } from '../middleware/auth';

const router = Router();

// All analytics routes require authentication
router.use(authenticate);

/**
 * @route   GET /api/analytics/overview
 * @desc    Get dashboard overview statistics
 * @access  Private
 */
router.get('/overview', analyticsController.getOverview);

/**
 * @route   GET /api/analytics/progress
 * @desc    Get detailed progress tracking
 * @access  Private
 */
router.get('/progress', analyticsController.getProgress);

/**
 * @route   GET /api/analytics/export
 * @desc    Export user data
 * @access  Private
 */
router.get('/export', analyticsController.exportData);

export default router;
