from textual import events, on
from textual.app import App, ComposeResult
from textual.containers import Container, Horizontal, Vertical
from textual.widgets import Header, Footer, Input, Button, Tree, Label, LoadingIndicator, DataTable, Static, TabbedContent, TabPane
from textual.screen import Screen, ModalScreen
from textual.binding import Binding
from textual.widgets._tree import TreeNode
from textual.reactive import reactive
from textual.containers import ScrollableContainer
from contextlib import asynccontextmanager

import asyncio
import subprocess
import json

@asynccontextmanager
async def loading_indicator(widget):
    loading = LoadingIndicator()
    widget.mount(loading)
    yield
    loading.remove()

class SearchInput(Input):
    def __init__(self):
        super().__init__(placeholder="Search secrets...", id="search_input")

class SecretTree(Tree):
    def __init__(self):
        super().__init__("Secrets", id="secret_tree")
        self.root.expand()

    async def on_mount(self):
        await self.load_secrets()

    async def load_secrets(self):
        self.root.remove_children()
        async with loading_indicator(self):
            secrets = await self.run_op_command(['op', 'item', 'list', '--format=json'])
            vaults = {}
            for secret in secrets:
                vault_name = secret['vault']['name']
                if vault_name not in vaults:
                    vaults[vault_name] = self.root.add(vault_name, expand=True)
                vaults[vault_name].add_leaf(secret['title'])

    async def run_op_command(self, command):
        process = await asyncio.create_subprocess_exec(
            *command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        stdout, stderr = await process.communicate()
        if process.returncode != 0:
            raise Exception(f"Command failed: {stderr.decode()}")
        return json.loads(stdout)

    def filter_secrets(self, search_term: str):
        def filter_node(node: TreeNode) -> bool:
            if search_term.lower() in node.label.lower():
                return True
            if node.children:  # This node is not a leaf if it has children
                return any(filter_node(child) for child in node.children)
            return False

        for node in self.root.children:
            node.visible = filter_node(node)
            if node.visible:
                node.expand()
            else:
                node.collapse()

class SecretDetailsScreen(Screen):
    def __init__(self, secret_name: str):
        super().__init__()
        self.secret_name = secret_name

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        yield TabbedContent(
            TabPane("Details", ScrollableContainer(DataTable(id="secret_details"))),
            TabPane("Raw JSON", Static(id="raw_json")),
        )
        yield Footer()

    async def on_mount(self):
        await self.load_secret_details()

    async def load_secret_details(self):
        async with loading_indicator(self):
            details = await self.run_op_command(['op', 'item', 'get', self.secret_name, '--format=json'])
            table = self.query_one("#secret_details")
            table.clear()
            table.add_column("Field", width=20)
            table.add_column("Value")
            for field in details['fields']:
                table.add_row(field['label'], field['value'] if 'value' in field else "[concealed]")

            raw_json = self.query_one("#raw_json")
            raw_json.update(json.dumps(details, indent=2))

class SecretListScreen(Screen):
    BINDINGS = [
        Binding("n", "new_secret", "New Secret"),
        Binding("e", "edit_secret", "Edit Secret"),
        Binding("d", "delete_secret", "Delete Secret"),
        Binding("q", "quit", "Quit"),
        Binding("/", "focus_search", "Search"),
        Binding("j", "move_cursor_down", "Move Down"),
        Binding("k", "move_cursor_up", "Move Up"),
        Binding("h", "collapse_node", "Collapse"),
        Binding("l", "expand_node", "Expand"),
        Binding("c", "copy_secret", "Copy Secret"),
    ]

    search_term = reactive("")

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        yield Container(
            SearchInput(),
            Horizontal(
                SecretTree(),
                Vertical(
                    Label("Secret Details", id="secret_details_label"),
                    DataTable(id="secret_details")
                )
            )
        )
        yield StatusBar()
        yield Footer()

    def on_tree_node_selected(self, event: Tree.NodeSelected):
        if not event.node.children:  # This node is a leaf if it has no children
            self.app.push_screen(SecretDetailsScreen(event.node.label))

    async def run_op_command(self, command):
        process = await asyncio.create_subprocess_exec(
            *command,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        stdout, stderr = await process.communicate()
        if process.returncode != 0:
            raise Exception(f"Command failed: {stderr.decode()}")
        return json.loads(stdout)

    def action_new_secret(self):
        self.app.push_screen(NewSecretScreen())

    def action_edit_secret(self):
        selected_node = self.query_one("#secret_tree").cursor_node
        if selected_node and not selected_node.children:
            self.app.push_screen(EditSecretScreen(selected_node.label, selected_node.parent.label))

    def action_delete_secret(self):
        selected_node = self.query_one("#secret_tree").cursor_node
        if selected_node and not selected_node.children:
            self.app.push_screen(
                DeleteConfirmationModal(selected_node.label),
                callback=self.handle_delete_confirmation
            )

    async def handle_delete_confirmation(self, confirmed: bool):
        if confirmed:
            await self.delete_secret(selected_node.label)

    async def delete_secret(self, secret_name: str):
        async with loading_indicator(self):
            await self.run_op_command(['op', 'item', 'delete', secret_name])
            self.update_status(f"Deleted secret: {secret_name}")
            await self.query_one(SecretTree).load_secrets()

    def on_input_changed(self, event: Input.Changed) -> None:
        if event.input.id == "search_input":
            self.search_term = event.value
            self.filter_secrets()

    def filter_secrets(self) -> None:
        secret_tree = self.query_one(SecretTree)
        secret_tree.filter_secrets(self.search_term)

    def action_focus_search(self) -> None:
        self.query_one(SearchInput).focus()

    def update_status(self, message: str):
        self.query_one(StatusBar).update(message)

    def action_move_cursor_down(self):
        self.query_one(SecretTree).action_cursor_down()

    def action_move_cursor_up(self):
        self.query_one(SecretTree).action_cursor_up()

    def action_collapse_node(self):
        self.query_one(SecretTree).action_collapse_node()

    def action_expand_node(self):
        self.query_one(SecretTree).action_expand_node()

    def action_copy_secret(self):
        selected_node = self.query_one("#secret_tree").cursor_node
        if selected_node and not selected_node.children:
            asyncio.create_task(self.copy_secret_to_clipboard(selected_node.label))

    async def copy_secret_to_clipboard(self, secret_name: str):
        async with loading_indicator(self):
            secret = await self.run_op_command(['op', 'item', 'get', secret_name, '--format=json'])
            password = next((field['value'] for field in secret['fields'] if field['label'].lower() == 'password'), None)
            if password:
                self.copy_to_clipboard(password)
                self.update_status(f"Copied password for {secret_name} to clipboard")
            else:
                self.update_status(f"No password found for {secret_name}")

    def copy_to_clipboard(self, text: str):
        try:
            # For macOS
            subprocess.run('pbcopy', universal_newlines=True, input=text)
        except FileNotFoundError:
            try:
                # For Windows
                subprocess.run('clip', universal_newlines=True, input=text)
            except FileNotFoundError:
                try:
                    # For Linux with xclip installed
                    subprocess.run(['xclip', '-selection', 'clipboard'], universal_newlines=True, input=text)
                except FileNotFoundError:
                    self.update_status("Clipboard functionality not available on this system")

class NewSecretScreen(Screen):
    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        yield Container(
            Label("Create New Secret", classes="title"),
            Input(placeholder="Secret Name", id="secret_name"),
            Input(placeholder="Username", id="username"),
            Input(placeholder="Password", password=True, id="password"),
            Input(placeholder="URL", id="url"),
            Input(placeholder="Vault Name", id="vault_name"),
            Button("Create", variant="primary", id="create_secret"),
            Button("Cancel", id="cancel")
        )
        yield Footer()

    @on(Button.Pressed, "#create_secret")
    async def create_secret(self):
        name = self.query_one("#secret_name").value
        username = self.query_one("#username").value
        password = self.query_one("#password").value
        url = self.query_one("#url").value
        vault = self.query_one("#vault_name").value

        command = [
            'op', 'item', 'create',
            '--category', 'login',
            '--title', name,
            '--vault', vault,
            f'username={username}',
            f'password={password}',
            f'url={url}'
        ]

        async with loading_indicator(self):
            result = await self.run_op_command(command)
            self.app.query_one(StatusBar).update(f"Created secret: {name}")

        await self.app.query_one(SecretTree).load_secrets()
        self.app.pop_screen()

    @on(Button.Pressed, "#cancel")
    def cancel(self):
        self.app.pop_screen()

class EditSecretScreen(Screen):
    def __init__(self, secret_name: str, vault_name: str):
        super().__init__()
        self.secret_name = secret_name
        self.vault_name = vault_name

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        yield Container(
            Label(f"Edit Secret: {self.secret_name}", classes="title"),
            Input(placeholder="New Secret Name", id="new_secret_name"),
            Input(placeholder="New Username", id="new_username"),
            Input(placeholder="New Password", password=True, id="new_password"),
            Input(placeholder="New URL", id="new_url"),
            Button("Update", variant="primary", id="update_secret"),
            Button("Cancel", id="cancel")
        )
        yield Footer()

    async def on_mount(self):
        await self.load_secret_details()

    async def load_secret_details(self):
        async with loading_indicator(self):
            details = await self.run_op_command(['op', 'item', 'get', self.secret_name, '--format=json'])
            self.query_one("#new_secret_name").value = details['title']
            for field in details['fields']:
                if field['label'].lower() == 'username':
                    self.query_one("#new_username").value = field['value']
                elif field['label'].lower() == 'password':
                    self.query_one("#new_password").value = field['value']
                elif field['label'].lower() == 'url':
                    self.query_one("#new_url").value = field['value']

    @on(Button.Pressed, "#update_secret")
    async def update_secret(self):
        new_name = self.query_one("#new_secret_name").value
        new_username = self.query_one("#new_username").value
        new_password = self.query_one("#new_password").value
        new_url = self.query_one("#new_url").value

        command = [
            'op', 'item', 'edit', self.secret_name,
            '--vault', self.vault_name,
            'title=' + new_name,
            'username=' + new_username,
            'password=' + new_password,
            'url=' + new_url
        ]

        async with loading_indicator(self):
            result = await self.run_op_command(command)
            self.app.query_one(StatusBar).update(f"Updated secret: {new_name}")

        await self.app.query_one(SecretTree).load_secrets()
        self.app.pop_screen()

    @on(Button.Pressed, "#cancel")
    def cancel(self):
        self.app.pop_screen()

class DeleteConfirmationModal(ModalScreen):
    def __init__(self, secret_name: str):
        super().__init__()
        self.secret_name = secret_name

    def compose(self) -> ComposeResult:
        yield Container(
            Label(f"Are you sure you want to delete '{self.secret_name}'?"),
            Horizontal(
                Button("Yes", variant="error", id="confirm_delete"),
                Button("No", variant="primary", id="cancel_delete")
            )
        )

    @on(Button.Pressed, "#confirm_delete")
    def confirm_delete(self):
        self.dismiss(True)

    @on(Button.Pressed, "#cancel_delete")
    def cancel_delete(self):
        self.dismiss(False)

class StatusBar(Static):
    def __init__(self):
        super().__init__("Ready", id="status_bar")

class OnePasswordTUI(App):
    CSS = """
    SecretTree {
        width: 30%;
        border: solid $accent;
        height: 100%;
    }
    #secret_details {
        height: 100%;
    }
    .title {
        text-align: center;
        text-style: bold;
    }
    #status_bar {
        dock: bottom;
        height: 1;
        padding: 0 1;
        background: $surface;
    }
    """

    BINDINGS = [
        Binding("ctrl+q", "quit", "Quit", priority=True),
    ]

    def on_mount(self) -> None:
        self.push_screen(SecretListScreen())

if __name__ == "__main__":
    app = OnePasswordTUI()
    app.run()
