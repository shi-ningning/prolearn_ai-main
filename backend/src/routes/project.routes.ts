import { Router } from 'express';
import * as projectController from '../controllers/project.controller';
import { authenticate } from '../middleware/auth';

const router = Router();

// All project routes require authentication
router.use(authenticate);

/**
 * @route   GET /api/projects
 * @desc    List user projects (with filtering)
 * @access  Private
 */
router.get('/', projectController.listProjects);

/**
 * @route   POST /api/projects
 * @desc    Create new project
 * @access  Private
 */
router.post('/', projectController.createProject);

/**
 * @route   GET /api/projects/:id
 * @desc    Get project details
 * @access  Private
 */
router.get('/:id', projectController.getProject);

/**
 * @route   PUT /api/projects/:id
 * @desc    Update project
 * @access  Private
 */
router.put('/:id', projectController.updateProject);

/**
 * @route   DELETE /api/projects/:id
 * @desc    Delete project
 * @access  Private
 */
router.delete('/:id', projectController.deleteProject);

export default router;
