import { useState } from "react";
import List from "./List";
import Form from "./Form";

function App() {
  const [items, setItems] = useState<string[]>([]);

  const addItem = (item: string) => {
    if (item.trim() === "") return;
    setItems([...items, item]);
  };

  const clearList = () => setItems([]);

  return (
    <div className="container">
      {/* left */}
      <div id="left-section" className="flex-center-column column">
        <List items={items} />
      </div>

      {/* right */}
      <div id="right-section" className="flex-center-column column">
        <div className="space-below">
          <Form buttonText="Add" onSubmit={addItem} />
        </div>
        <button onClick={clearList}>Clear</button>
      </div>
    </div>
  );
}

export default App;
