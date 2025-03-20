import { useState } from "react";
import List from "./List";
import Form from "./Form";
import { Item } from "./Item";

function App() {
  const [items, setItems] = useState<Item[]>([]);

  const addItem = (item: Item) => {
    setItems([...items, item]);
  };

  const clearList = () => setItems([]);

  const removeItem = (id: number) => {
    setItems(items.filter(item => item.id !== id));
  }

  return (
    <div className="container">
      {/* left */}
      <div id="left-section" className="column">
        <List items={items} removeItem={removeItem}/>
      </div>

      {/* right */}
      <div id="right-section" className="flex-center-column column">
        <div className="space-below">
          <Form buttonText="Add" onSubmit={addItem} />
        </div>
        <button className="text-button" onClick={clearList}>Clear</button>
      </div>
    </div>
  );
}

export default App;
