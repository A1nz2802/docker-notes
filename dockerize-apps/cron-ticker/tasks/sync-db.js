let times = 0

const syncDB = () => {
  times++;
  console.log('tick every 5 seconds', times);
  
  return times;
}

export {
  syncDB
}