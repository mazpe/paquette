
  function confirmDelete(anchor)
  {
    if (confirm('Are you sure?'))
    {
        document.location.href = anchor;
        return true;
    }
    return false;
  }

