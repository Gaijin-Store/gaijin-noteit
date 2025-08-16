(function () {
  const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'gaijin-noteit';
  const POST = (name, body = {}) =>
    fetch(`https://${RES}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(body),
    }).catch(() => {});

  const overlay   = document.getElementById('webnoteit');    
  const textarea  = document.getElementById('noteText');     
  const btnOK     = document.getElementById('submitBtn');    
  const btnCancel = document.getElementById('closeBtn');     

  const state = { open: false, max: 160, busy: false };

  function show() {
    state.open = true;
    overlay.style.display = 'flex';
    textarea.value = '';
    textarea.focus();
  }
  function hide() {
    state.open = false;
    overlay.style.display = 'none';
  }

  window.addEventListener('message', (e) => {
    const data = e.data || {};
    if (data.action === 'open') {
      state.max = Number(data.max || 160);
      textarea.maxLength = state.max;
      state.busy = false;
      show();
    } else if (data.action === 'close') {
      hide();
    }
  });

  async function submitNote() {
    if (!state.open || state.busy) return;
    const text = String(textarea.value || '').substring(0, state.max).trimEnd();
    if (!text.length) return;

    state.busy = true;
    await POST('createNoteit', { text });
    state.busy = false;
    await closeNui();
  }

  async function closeNui() {
    if (!state.open) return;
    await POST('close', {});
    hide();
  }

  if (btnOK) btnOK.addEventListener('click', (e) => { e.preventDefault(); submitNote(); });
  if (btnCancel) btnCancel.addEventListener('click', (e) => { e.preventDefault(); closeNui(); });

  document.addEventListener('keydown', (e) => {
    if (!state.open) return;
    if (e.key === 'Escape') { e.preventDefault(); closeNui(); }
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') { e.preventDefault(); submitNote(); }
  });

  overlay.style.display = 'none';
})();
