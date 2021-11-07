console.log('canEdit', window.canEdit);
const keyboard = document.querySelector('.keyboard');
const scores = document.querySelector('.scores');
const totalScore = document.querySelector('#total');

function clearColors() {
  for (let i = 0; i < scores.children.length; i++) {
    scores.children[i].style.backgroundColor = '#efefef';
  }
}

function updateColorForNode(target) {
  clearColors();

  target.style.backgroundColor = 'lightgreen';
}

function updateScore({ currentArrow, score }) {
  if (!window.canEdit) return;
  fetch(`${window.location.href}/update_score`, {
    method: 'POST',
    body: JSON.stringify({ current_arrow: currentArrow, score }),
  }).catch(console.error);
}

function calculateAndUpdateTotal() {
  const total = Array.from(scores.children).reduce((acc, score) => {
    if (score.innerText === '') return acc;
    const value = score.innerText === 'X' ? 10 : parseInt(score.innerText);
    return acc + value;
  }, 0);
  totalScore.innerText = total;
}

function init() {
  if (!window.canEdit) {
    setInterval(() => {
      window.location.reload();
    }, 10_000);
    return;
  }
  let currentArrow = null;
  scores.addEventListener('click', (event) => {
    keyboard.style.display = 'grid';
    currentArrow = parseInt(event.target.value);
    updateColorForNode(event.target);
  });

  keyboard.addEventListener('click', (event) => {
    const score = event.target.id;

    updateScore({ currentArrow, score });
    scores.children[currentArrow].innerText = score;
    calculateAndUpdateTotal();
    if ((currentArrow + 1) % 3 === 0) {
      keyboard.style.display = 'none';
      clearColors();
      return;
    }

    currentArrow++;
    updateColorForNode(scores.children[currentArrow]);
  });
}

init();
