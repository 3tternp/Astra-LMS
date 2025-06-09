import { useMemo } from 'react';
import { jwtDecode } from 'jwt-decode';

export const useAuth = () => {
  const token = localStorage.getItem('accessToken');

  const user = useMemo(() => {
    if (!token) return null;
    try {
      return jwtDecode(token); // Assumes payload has role, user_id, etc.
    } catch (e) {
      return null;
    }
  }, [token]);

  return { user };
};
