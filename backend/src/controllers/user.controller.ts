import { Request, Response } from 'express';
import { User } from '../models';

/**
 * Create or update user in MongoDB (called after Firebase Auth registration)
 */
export const createOrUpdateUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { uid, email, displayName, studentId, section, course } = req.body;

    if (!uid) {
      res.status(400).json({
        success: false,
        error: { code: 'INVALID_REQUEST', message: 'User UID is required' }
      });
      return;
    }

    // Check if user already exists
    let user = await User.findOne({ uid });

    if (user) {
      // Update existing user
      user.email = email || user.email;
      user.displayName = displayName || user.displayName;
      user.lastLoginAt = new Date();
      await user.save();
    } else {
      // Create new user in MongoDB
      user = await User.create({
        uid,
        email,
        displayName,
        role: 'student',
        preferences: {
          language: 'en',
          theme: 'light',
          notifications: true,
        },
        progress: {
          totalTasksCompleted: 0,
          totalStudyHours: 0,
          currentStreak: 0,
          longestStreak: 0,
        },
        lastLoginAt: new Date(),
      });
    }

    res.status(200).json({
      success: true,
      data: {
        user: {
          id: user._id,
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          role: user.role,
        }
      },
      message: user ? 'User profile updated' : 'User created successfully'
    });
  } catch (error: any) {
    console.error('Error creating/updating user:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: error.message || 'Failed to create/update user' }
    });
  }
};

export const getUserProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    
    const user = await User.findOne({ uid: id });

    if (!user) {
      res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: { user }
    });
  } catch (error: any) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: error.message }
    });
  }
};

export const updateUserProfile = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const updates = req.body;

    const user = await User.findOneAndUpdate(
      { uid: id },
      { $set: updates },
      { new: true, runValidators: true }
    );

    if (!user) {
      res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: { user },
      message: 'Profile updated successfully'
    });
  } catch (error: any) {
    console.error('Error updating user profile:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: error.message }
    });
  }
};

export const getUserStats = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    
    const user = await User.findOne({ uid: id });

    if (!user) {
      res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: {
        stats: {
          totalTasksCompleted: user.progress.totalTasksCompleted,
          totalStudyHours: user.progress.totalStudyHours,
          currentStreak: user.progress.currentStreak,
          longestStreak: user.progress.longestStreak,
        }
      }
    });
  } catch (error: any) {
    console.error('Error fetching user stats:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: error.message }
    });
  }
};

export const deleteUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    
    const user = await User.findOneAndDelete({ uid: id });

    if (!user) {
      res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error: any) {
    console.error('Error deleting user:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: error.message }
    });
  }
};
