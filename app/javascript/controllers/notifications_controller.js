import { Controller } from "stimulus";

export default class extends Controller {
  markAsRead(event) {
    const notificationId = event.currentTarget.dataset.notificationId;

    fetch(`/notifications/${notificationId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ checked: true })
    })
    .then(response => {
      if (response.ok) {
        // 通知が確認済みとして一覧から削除
        event.currentTarget.closest('li').remove();
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
}
