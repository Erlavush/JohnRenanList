package com.example.john_renan_list

import android.content.Intent
import android.widget.RemoteViewsService

class DeadlineWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return DeadlineListProvider(this.applicationContext, intent)
    }
}
