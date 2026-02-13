import { useState } from 'react'
import './App.css'

function App() {

  const [count, setCount] = useState(0)
  const handleClick = () => {
    alert('Button clicked!')
  }

  return (
    <>
      <h1>
        Hello Webodoctor
      </h1>
      <button onClick={handleClick}>Click me</button>

      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
