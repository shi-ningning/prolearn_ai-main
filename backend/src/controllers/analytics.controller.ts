import { Request, Response } from 'express';

export const getOverview = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const getProgress = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const exportData = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};
