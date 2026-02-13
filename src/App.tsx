import './App.css'

function App() {

  const handleClick = () => {
    alert('Button clicked!')
  }
  return (
    <>
      <h1>
        Hello Webodoctor
      </h1>
      <button onClick={handleClick}>Click me</button>
    </>
  )
}

export default App
