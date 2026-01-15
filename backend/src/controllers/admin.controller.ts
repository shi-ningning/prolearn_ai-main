import { Request, Response } from 'express';

export const listUsers = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const getSystemStats = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const createAnnouncement = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const deleteUser = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};
