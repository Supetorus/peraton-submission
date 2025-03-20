export interface Item {
    value: string;
    id: number;
}

let id = 0;

export function generateId() {
    return id++;
}