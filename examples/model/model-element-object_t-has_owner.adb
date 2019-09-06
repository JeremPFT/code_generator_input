function Has_Owner
  (Self: in Object_T)
  return Boolean
  is (Self.Owner /= null);
